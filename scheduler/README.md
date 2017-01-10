# Schedule component

installer를 통해 서버 컴포넌트나 주기적 실행이 필요한 컴포넌트를 등록한다.

 * mac의 경우에는 plist 파일을 ~/Library/LaunchAgents에 symblic link하여 실행
 * mac의 crontab의 경우 재부팅후 삭제되는 경우가 있으므로 주기적으로 설정
 * windows의 경우 powershell을 통해 추가
 * daily-auto-commit의 경우 "메인 컴퓨터"에서만 등록을 원칙으로 함.