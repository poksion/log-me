# Scheduler / Install

installer를 통해 서버 컴포넌트나 주기적 실행이 필요한 컴포넌트를 등록합니다.

 * mac의 경우에는 plist 파일을 ~/Library/LaunchAgents에 symblic link하여 실행
 * mac의 crontab의 경우 재부팅후 삭제되는 경우가 있으므로 주기적으로 설정
 * windows의 경우 powershell을 통해 추가
 * daily-auto-commit의 경우 "메인 컴퓨터" 하나에만 등록을 원칙으로 함.

## 스케쥴 등록이 필요한 컴포넌트

 * fyac : 기본적으로 localhost:9494 를 사용하는 웹서버입니다. 웹 활동을 기록하기 위해 부팅시 실행이 필요합니다.
 * worklog : 매분 주기적인 로깅을 위해 스케쥴러 등록이 필요합니다.
 * daily-auto-commit : 하루에 한번 자동 기록된  notes history를 커밋하기 위해 스케쥴러 등록이 필요합니다.

## 주의 사항

 * mac-crontab-adder를 사용할 경우 worklog 와 daily-auto-commit을 자동 등록합니다.
 
### workspace

log-me 프로젝트가 있는 디렉토리에 의존적인 동작들이 몇가지 있습니다.

 * plist에서, 작업공간을 ~/workspace/log-me 로 가정하고 있습니다. 만일 다른 작업공간을 사용한다면 변경해야 합니다.
 * crontab-adder에서도 작업공간을 ~/workspace/log-me 로 가정하고 있습니다.
 * 다른 대부분의 작업의 경우 config.yml 에 있는 디렉토리 정보를 가지고 작업을 수행합니다.
 * config.yml이 없을 경우 default config 파일인 config.template.yml을 읽어 수행합니다.