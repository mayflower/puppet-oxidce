# = Definition: oxidce::repo
#
# This definition clones a specific version from a OXID
# repository into the specified directory.
#
# == Parameters: 
#
# $directory::     The oxid ce repository will be checked out/cloned into this 
#                  directory.
# $version::       The oxid ce version. Defaults to 'trunk'. 
#                  Valid values: For example 'HEAD', 'tags/1.8.3' or 'branch/whatever'.
# $repository::    Whether to checkout the SVN or Git reporitory. Defaults to svn. 
#                  Valid values: 'svn' and 'git'.  
# $svn_username::  Your svn username. Defaults to false.
# $svn_password::  Your svn password. Defaults to false.
#
# == Actions:
#
# == Requires: 
#
# == Sample Usage:
#
#  oxidce::repo { 'oxidce_repo_simple': }
#
#  oxidce::repo { 'oxidce_repo_full':
#    directory    => '/var/www/', # OXID CE sits in its own eshop directory
#    version      => 'trunk',
#    repository   => 'svn',
#    svn_username => 'svn username',
#    svn_password => 'svn password'
#  }
#
define oxidce::repo(
  $directory    = $oxidce::params::docroot,
  $version      = $oxidce::params::oxidce_version,
  $repository   = $oxidce::params::repository,
  $svn_username = false,
  $svn_password = false
) {

  if ! defined(File[$directory]) {
    file { "${directory}": }
  }

  if $repository == 'svn' {
    vcsrepo { "${directory}":
      ensure   => present,
      provider => svn,
      source   => "${oxidce::params::svn_repository}/${version}",
      owner    => $oxidce::params::user,
      group    => $oxidce::params::group,
      require  => [ User["${oxidce::params::user}"], Package['subversion'] ],
      basic_auth_username => $svn_username,
      basic_auth_password => $svn_password,
    }
  }

# git currently not supported by OXID
#
#  if $repository == 'git' {
#    vcsrepo { "${directory}":
#      ensure   => present,
#      provider => git,
#      source   => $oxidce::params::git_repository,
#      revision => $version,
#      owner    => $oxidce::params::user,
#      group    => $oxidce::params::group,
#      require  => [ User["${oxidce::params::user}"], Class['git'] ],
#    }
#  }

  file { "${directory}/config":
    ensure    => directory,
    mode      => '0777',
    subscribe => Vcsrepo["${directory}"],
  }

  file { "${directory}/tmp":
    ensure    => directory,
    mode      => '0777',
    subscribe => Vcsrepo["${directory}"],
  }

}
