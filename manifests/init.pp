# = Class: oxidce
# 
# This class installs all required packages and services in order to run OXID CE. 
# It'll do a checkout of the OXID CE repository as well. You only have to setup
# Apache and/or NGINX afterwards.
# 
# == Parameters: 
#
# $directory::         The oxid repository will be checked out into this directory.
# $repository::        Whether to checkout the SVN or Git reporitory. Defaults to svn. 
#                      Valid values: 'svn' and 'git'. 
# $version::           The OXID CE version. Defaults to 'trunk'. 
#                      Valid values: For example 'tags/1.8.3' or 'branch/whatever'. 
# $db_user::           If defined, it creates a MySQL user with this username.
# $db_password::       The MySQL user's password.
# $db_root_password::  A password for the MySQL root user.
# $log_analytics::     Whether log analytics will be used. Defaults to true. 
#                      Valid values: true or false
# $svn_username::      Your svn username. Defaults to false.
# $svn_password::      Your svn password. Defaults to false.
# 
# == Requires: 
# 
# See README
# 
# == Sample Usage:
#
#  class {'oxidce': }
#
#  class {'oxidce':
#    db_root_password => '123456',
#    repository => 'git',
#  }
#
class oxidce(
  $directory   = $oxidce::params::apachedocroot,
  $repository  = $oxidce::params::repository,
  $version     = $oxidce::params::oxidce_version,
  $db_user     = $oxidce::params::db_user,
  $db_password = $oxidce::params::db_password,
  $db_root_password = $oxidce::params::db_password,
  $log_analytics    = true,
  $svn_username     = false,
  $svn_password     = false
) inherits oxidce::params {

  include oxidce::base

  # mysql / db
  class { 'oxidce::db':
    username      => $db_user,
    password      => $db_password,
    root_password => $db_root_password,
    require       => Class['oxidce::base'],
  }

  class { 'oxidce::php':
     require => Class['oxidce::db'],
  }

  class { 'oxidce::user': }

  # repo checkout
  oxidce::repo { 'oxidce_repo_setup':
    directory    => $directory,
    version      => $version,
    repository   => $repository,
    svn_username => $svn_username,
    svn_password => $svn_password,
    require      => Class['oxidce::base'],
  }

}

