#{
#
#    "local" : {
#        "bin" : [
#        ],
#
#        "bin-mac" : [
#        ],
#
#        "bin-mac-opt" : [
#        ],
#        
#        "conf" : [
#        ],
#
#        "conf-linux" : [
#        ],
#
#        "conf-mac" : [
#        ],
#
#        "dev-tools" : [
#        ],
#
#        "dev-workspace" : [
#        ]
#    },
#
#    "from_nas" : {
#        "bin" : [
#        ],
#
#        "bin-mac" : [
#        ],
#
#        "bin-mac-opt" : [
#        ]
#    },
#
#    "to_nas" : {
#        "bin" : [
#            "ngrep"
#        ],
#
#        "bin-mac" : [
#        ],
#
#        "bin-mac-opt" : [
#            "dn"
#        ]
#    }
#}

class DevSyncTarget
    attr_reader(:repositories)

    def initialize
        @repositories = Hash.new

        @repositories['bin'] = {
            :path => {
                'bin' => '~/bin',
                'bin-mac' => '~/bin-mac'
            },
            
            :items => {
                'bin-mac-opt' => '/opt/local/bin/dn'
            }
        }
        
        @repositories['conf'] = {
            :items => {
                'conf' => '~/.vim;~/.vimrc;~/vrapperrc',
                'conf-linux' => '~/.bashrc',
                'conf-mac' => '~/.bash_profile'
            }
        }
        
        @repositories['dev'] = {
            :items => {
                'dev-tools' => '/Applications/eclipse'
            },

            :path => {
                'dev-workspace' => '~/workspace'
            }
        }
    end
end
