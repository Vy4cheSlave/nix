{ config, pkgs, ... }:

  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
{
  programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
      languagePacks = [ "ru" ];

      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = false;
        DisableAccounts = false;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed"
        # how to find id addons "about:debugging#/runtime/this-firefox"
        ExtensionSettings = {
          "*".installation_mode = "allowed"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Catppuccin Mocha - Blue:
          "{2adf0361-e6d8-4b74-b3bc-3f450e8ebb69}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/3989617/catppuccin_mocha_blue_git-2.0.xpi";
            installation_mode = "force_installed";
          };
          # TWP - Translate Web Pages:
          "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4455681/traduzir_paginas_web-10.1.1.1.xpi";
            installation_mode = "force_installed";
          };
          # Tampermonkey:
          "firefox@tampermonkey.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4578764/tampermonkey-5.4.0.xpi";
            installation_mode = "force_installed";
          };
          # Dark Reader:
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4598977/darkreader-4.9.112.xpi";
            installation_mode = "force_installed";
          };
        };
  
        /* ---- PREFERENCES ---- */
        # Check about:config for options.
        Preferences = {
          "privacy.resistFingerprinting" = lock-false;
          "ui.systemUsesDarkTheme" = lock-true;
          "sidebar.animation.enabled" = lock-false;
          "sidebar.main.tools" = { Value = "history,syncedtabs,bookmarks"; Status = "locked"; };
          "sidebar.position_start" = lock-true;
          "sidebar.revamp" = lock-true;
          "sidebar.visibility" = { Value = "hide-sidebar"; Status = "locked"; };
          "sidebar.verticalTabs" = lock-true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = lock-true;
          "browser.translations.enable" = lock-false;
          "identity.fxaccounts.enabled" = { Value = true; Status = "locked"; };  # Включение синхронизации
          "browser.startup.page" = { Value = 3; Status = "locked"; }; # 1: новые вкладки, 2: домашняя страница, 3: предыдущие вкладки
          "browser.sessionstore.resume_from_crash" = lock-true; # Восстанавливать предыдущие вкладки после сбоя
          "browser.sessionstore.resume_session" = lock-true; # Восстанавливать предыдущую сессию, если Firefox был закрыт 
        #  "browser.contentblocking.category" = { Value = "standard"; Status = "locked"; }; # been set "strict"
        #  "extensions.pocket.enabled" = lock-false;
        #  "extensions.screenshots.disabled" = lock-true;
        #  "browser.topsites.contile.enabled" = lock-false;
        #  "browser.formfill.enable" = lock-false;
        #  "browser.search.suggest.enabled" = lock-false;
        #  "browser.search.suggest.enabled.private" = lock-false;
        #  "browser.urlbar.suggest.searches" = lock-false;
        #  "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        #  "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        #  "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        #  "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        #  "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        #  "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        #  "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        #  "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        #  "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        #  "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
      };
    
  };
}

