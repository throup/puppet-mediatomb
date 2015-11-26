# == Class: mediatomb
#
# Full description of class mediatomb here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the function of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'mediatomb':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class mediatomb (
  $interface   = regsubst($interfaces,'^([^,]+),([^,]+),.*$', '\1'),
  $port        = 50500,
  $uuid        = chomp(generate('/usr/bin/uuidgen')),
  $servicename = 'MediaTomb'
) {
  package {'mediatomb':
    ensure => 'present',
  }

  file { 'mediatomb.conf':
    ensure => file,
    path => '/etc/mediatomb.conf',
    content => epp('mediatomb/mediatomb.conf.epp', {'interface' => $interface, 'port' => $port}),
    require => Package['mediatomb'],
  }

  file { 'config.xml':
    ensure => file,
    path => '/etc/mediatomb/config.xml',
    content => epp('mediatomb/config.xml.epp', {'uuid' => $uuid, 'servicename' => $servicename}),
    require => Package['mediatomb'],
  }

  service {'mediatomb':
    ensure => 'running',
    enable => 'true',
    require => [ File['mediatomb.conf'], File['config.xml'] ],
  }
}
