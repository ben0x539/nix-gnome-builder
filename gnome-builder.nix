{ pkgs ? import <nixpkgs> { } }:

with pkgs;

stdenv.mkDerivation rec {
  name = "gnome-builder-${version}";
  version = "3.25.2-a11c9dfa";

  buildInputs = [
    libxml2 desktop_file_utils llvm clang libgit2 gobjectIntrospection librsvg
    json_glib mm-common enchant libtool fuse libgsystem ostree polkit ctags
    libssh2 meson sysprof
  ] ++ (with gnome3; [
     glib glib.dev gtk gtksourceview libpeas devhelp libgit2-glib
     webkitgtk gsettings_desktop_schemas dconf gspell adwaita-icon-theme
  ]);

  propagatedBuildInputs = with python3Packages; [
    python pygobject3 lxml jedi docutils six chardet urllib3 sphinx_rtd_theme
    pbr funcsigs mock imagesize markupsafe jinja2 pygments snowballstemmer
    requests alabaster pytz Babel sphinx
  ];

  nativeBuildInputs = [
    pkgconfig meson ninja autoconf automake wrapGAppsHook
    yacc flex intltool itstool
  ];

  propagatedUserEnvPkgs = [
    ctags
  ];

  wrapPrefixVariables = "PYTHONPATH";

  preConfigure = ''
    ./autogen.sh
    PYTHONPATH="$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
  '';

  enableParallelBuilding = true;

  src = fetchgit {
    url = https://git.gnome.org/browse/gnome-builder;
    rev = "a11c9dfad6d39d5686ad8cb3885f898696e218d6";
    sha256 = "0p08zr798fh7lycfybzvyx63m55z13afs1adrsmn7vhrbn0az934";
  };
}
