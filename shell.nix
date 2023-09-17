{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    pandoc
    python311
    python311Packages.panflute
    python311Packages.python-dateutil
    python311Packages.python-frontmatter
    python311Packages.pytz
    python311Packages.feedgenerator
    librsvg
    texlive.combined.scheme-full
    inconsolata
  ];
}
