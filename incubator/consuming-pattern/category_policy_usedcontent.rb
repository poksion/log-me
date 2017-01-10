# encoding: utf-8

require_relative 'category_manager'
require_relative 'category_policy'

class CategoryPolicyUsedContent < CategoryPolicy
    
    def initialize
        @scheme = [
            ['카페/빵집', 'dddd00', ['커피빈','스타벅스','나무그늘','파리바게트','카페','커피','맥도날드','아워홈','뺑드','뚜레쥬르','커핀그루나루','파리바게뜨','엔제리너스','엔제리너스','파스쿠찌','탐앤탐스','누들박스','패티패티','제너시스비비큐','빵터지는집','벤스','독일분식','비스켓','공차코리아','안데르센과자점','도너츠','폴바셋','크리스피','로쏘','어메이징브라더스','헬로에프비엘','코리아세븐','코피티암','PUB N PUBS'] ],
            ['자동차/세금관련', 'ff0000', ['주유소', '오일','서울33','서울34','서울31','대전60','삼성화재','석유','자동차세','지방세','글로벌 피엠코','와이퍼'] ],
            ['책/영화/공연', 'aa00aa', ['문고','메가박스','예스이십사','메인티켓','성남아트'] ],
            ['쇼핑', '00aaee', ['롯데','인터파크','이마트','굿모닝마트','바이더웨이','GS25','쇼핑','11번가','세븐일레븐','홈플러스','마켓','현대백','갤러리아','다비앙','한샘','미니스톱','LG전자','씨유','오픈오디오','유통','신세계','아울렛','씨제이','컴퓨존','소프트','후니드','옥션','GOOGLE','블루웹','아이엠펀','시노'] ],
            ['의료', '00aa00', ['약국','의원', '외과'] ],
            ['리조트/여행', '0000ff', ['리조트','에어프랑스','항공','NARITA','삼성에버랜드','인천에어네트워크','Hotel','SNCF','CART','AIR FR','PRINTEMPS','SBB','국립자연휴양림','휴게소','RAILEUROPE','HOTEL','르씨에나'] ],
            ['외식', 'ffee33', ['치킨','삐꼴로','도스타코스','감자탕','국시쿡시','파스타','식당','푸드','밥상','미스터쭈꾸미','피자헛','닐리','쏘렐라','산들채','버거킹','신맥','을파소','구워말어','맥주창고','연타발','논나스','순두부','제과','포차','통닭','블루밍가든','베스킨라빈스','오리엔탈스푼','족발','딘타이펑','리틀라이건','아사히','마마스','교동전','포에이','바순','The 율','아리가또맘마','아브뉴프랑','명동교자','포베이','황소고집','면옥','명동칼국수','스테이크','만다린','조개구이','찜닭','순대국','농장','밀사랑','뚝배기','삼계탕','벨라로사','세이순','KFC','산수화','치어스','쇼군','칸지고고','경성양육관','영농호정','아비꼬','대명성','개화','카에데','비니에올리','내뜨락'] ],
            ['통신/관리비', '00ff00', ['통신','SHOW요금','Olleh요금','SK텔레콤'] ],
            ['대중교통', 'aa0000', ['지하철','버스','고속철도','코레일','택시'] ],
            ['기부', 'aaffdd', ['유니세프'] ],
            ['기타', 'dd00dd', [''] ],
        ]
    end
    
    def on_init( category_manager )
        @scheme.each do | element |
            category_manager.add_category(element[0], element[1])
        end
    end
    
    def on_add_money( category_manager, category_year, category_month, card_type, used_date, used_content, used_money, dis_count, point)
        if used_money == 0
            return
        end
        @scheme.each do | element |
            words = element[2]
            words.each do | word |
                if used_content.include? word
                    category_manager.add_money(element[0], category_year, category_month, used_money)
                    if element[0] == '기타'
                        puts "#{category_year}.#{category_month} - #{used_content}"
                    end
                    return
                end
            end
        end
    end

end
