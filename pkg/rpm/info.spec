#
# RPM Spec file for the WaTTS info plugin.
# Clones github.com:indigo-dc/tts_plugin_info and checks out %version.
#
# Under any yum based distro (e.g. CentOS) install `rpmdevtools' and then run:
#  $ rpmbuild -bb pkg/rpm/info.spec
#
# Maintainer: Joshua Bachmeier <uwdkl@student.kit.edu>
#

# Disable automatic rpm python bytecompiler  *ahem* Bloat *ahem*
# See https://math-linux.com/linux/rpm/article/how-to-turn-off-avoid-brp-python-bytecompile-script-in-a-spec-file
%global __os_install_post %(echo '%{__os_install_post}' | sed -e 's!/usr/lib[^[:space:]]*/brp-python-bytecompile[[:space:]].*$!!g')

Name:           watts-plugin-info
Summary:        WaTTS Info Plugin
Vendor:         INDIGO DataCloud
Packager:       Joshua Bachmeier <uwdkl@student.kit.edu>
Version:    	  v1.1.0
Release:    	  1
License:    	  Apache
Source:         tts_plugin_info
Requires:       python
Requires:       tts
BuildArch:	    noarch

%description
A simple plugin for WaTTS, displaying all the informations the plugin gets

%prep
cd $RPM_SOURCE_DIR
rm -rf tts_plugin_info
git clone https://github.com/indigo-dc/tts_plugin_info.git
cd tts_plugin_info
git checkout %version

%install
mkdir -p "$RPM_BUILD_ROOT/var/lib/watts/plugins"
install -m733 -t "$RPM_BUILD_ROOT/var/lib/watts/plugins" "$RPM_SOURCE_DIR/tts_plugin_info/plugin/info.py"

%clean
rm -rf %RPM_BUILD_ROOT

%files
/var/lib/watts/plugins/info.py
