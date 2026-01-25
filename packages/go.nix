{ pkgs, ... }:
{
  home.packages = [
    pkgs.go_1_24
    pkgs.grpcurl
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN  = "$HOME/go/bin";
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];
}