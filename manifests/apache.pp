# = Definition: oxidce::apache
#
# This definition installs Apache2 including some modules like
# mod_rewrite and creates a virtual host.
#
# == Parameters: 
#
# $name::      The name of the host
# $port::      The port to configure the host
# $priority::  The priority of the site
# $docroot::   The location of the files for this host
#
# == Actions:
#
# == Requires: 
#
# The oxidce class
#
# == Sample Usage:
#
#  oxidce::apache { 'apache.oxidce': }
#
#  oxidce::apache { 'apache.oxidce':
#    port     => 80,
#    priority => '10',
#    docroot  => '/var/www/oxidce',
#  }
#
define oxidce::apache (
  $port     = '80',
  $docroot  = $oxidce::params::apachedocroot,
  $priority = '10'
) {  

  host { "${name}":
    ip => "127.0.0.1";
  } 

  include apache

  include apache::mod::php
  include apache::mod::auth_basic
  # TODO move this to a class and include it. This allows us to define multiple apache hosts
  apache::mod {'vhost_alias': }
  apache::mod { 'rewrite': }

  apache::vhost { "${name}":
    priority   => $priority,
    vhost_name => '_default_',
    port       => $port,
    docroot    => $docroot,
    override   => 'all',
    require    => [ Host[$name], Oxidce::Repo['oxidce_repo_setup'], Class['oxidce::php'] ],
    configure_firewall => true,
  }

}
