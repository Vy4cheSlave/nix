{ config, pkgs, lib, ... }:
let
  user = config.system.primaryUser;
  pacPath = "/Users/${user}/.config/proxy/auto.pac";

  applyPac = pkgs.writeShellScript "apply-pac" ''
    set -euo pipefail

    if [ ! -f "${pacPath}" ]; then
      echo "[proxy-pac] PAC not found: ${pacPath}"
      exit 0
    fi

    networksetup -listallnetworkservices | tail -n +2 | while IFS= read -r svc; do
      [ -z "$svc" ] && continue

      # На некоторых версиях/локалях встречается строка-маркер со '*'
      # (или звёздочка в начале строки). Пропускаем такие.
      case "$svc" in
        \** ) continue ;;
      esac

      echo "[proxy-pac] applying to: $svc"

      # 1) Жёстко выключаем WPAD
      networksetup -setproxyautodiscovery "$svc" off || true

      # 2) Жёстко выключаем ручные прокси
      networksetup -setwebproxystate "$svc" off || true
      networksetup -setsecurewebproxystate "$svc" off || true
      networksetup -setsocksfirewallproxystate "$svc" off || true

      # 3) Переустанавливаем PAC (выкл → url → вкл) — так надёжнее
      networksetup -setautoproxystate "$svc" off || true
      networksetup -setautoproxyurl "$svc" "file://${pacPath}" || true
      networksetup -setautoproxystate "$svc" on || true
    done
  '';
in {
  system.activationScripts.proxyPac.text = ''
    ${applyPac}
  '';

  launchd.daemons.proxy-pac = {
    serviceConfig = {
      Label = "local.proxy-pac";
      ProgramArguments = [ "${applyPac}" ];
      RunAtLoad = true;
      StartInterval = 120;

      StandardOutPath = "/var/log/proxy-pac.log";
      StandardErrorPath = "/var/log/proxy-pac.err";
    };
  };
}
