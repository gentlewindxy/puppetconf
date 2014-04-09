import "nodes.pp"

node default {
#	include transcoder		
#	include coordinator
#	include admin::augeas
#	include fmagent

	file{ "/tmp/helloword.txt":
		content => "hello",
	}

fdsfi{
;dfd;
}
}


node arcvideo80 {
	#include ganglia

	
}
