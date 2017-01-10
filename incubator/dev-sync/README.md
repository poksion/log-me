dev-sync
========

개발 환경 백업 및 복구 솔루션. Chef처럼 전체 개발 환경을 만들어주지는 않으나 최소 개발 환경 및 개발 환경 공유를 편하게 할수 있는 용도로 활용한다.

## 사용법

```
ruby dev-sync.rb report
ruby dev-sync.rb report NAS_DIRECTORY
ruby dev-sync.rb report NAS_DIRECTORY > SYNC_JSON_FILENAME
ruby dev-sync.rb sync SYNC_JSON_FILENAME
```

## target

sync할 target은 dev_sync_target.rb 파일에서 수정하시어 사용하시면 됩니다. path 는 해당 항목의 첫번째 아이템들 모두를 나타내며, items는 ;의 결합으로 이루어진 개별 아이템을 나타냅니다.

```ruby
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
```
