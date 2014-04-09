class admin::augeas {
	package { ["augeas",
			   "augeas-libs",
			   "augeas-devel",
			   "ruby-augeas", ]:
		ensure => present,
	}
}