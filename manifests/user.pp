# = Class: oxidce::user
# 
# Makes sure the user exists which is used by Apache and NGINX.
# 
# == Parameters: 
# 
# == Requires: 
# 
# == Sample Usage:
#
#  include oxidce::user
#
class oxidce::user {
    
  # user for apache / nginx
  user { "${oxidce::params::user}":
    ensure  => present,
    comment => $oxidce::params::user,
    shell   => '/bin/false',
  }

}
