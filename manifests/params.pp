# = Class: oxidce::params
# 
# This class manages OXID CE parameters
# 
# == Parameters: 
# 
# == Requires: 
# 
# == Sample Usage:
#
# This class file is not called directly
#
class oxidce::params {
  $user    = 'www-data'
  $group   = 'www-data'
  $docroot = '/var/www/oxidce'
  $apachedocroot = '/var/www/oxidce/eshop'

  $repository     = 'svn'
  $svn_repository = 'http://svn.oxid-esales.com/'
  $oxid_version  = 'trunk'

  $db_user     = 'oxidce'
  $db_password = 'oxidce'
}
