# 한국복지패널데이터
# • 한국보건사회연구원 발간
# • 가구의 경제활동을 연구해 정책 지원에 반영할 목적
# • 2006~2015년까지 전국에서 7000여 가구를 선정해 매년 추적 조사
# • 경제활동, 생활실태, 복지욕구 등 수천 개 변수에 대한 정보로 구성

# 패키지 준비하기
install.packages("foreign") # foreign 패키지 설치
library(foreign)            # SPSS 파일 로드
library(dplyr)              # 전처리
library(ggplot2)            # 시각화
library(readxl)             # 엑셀 파일 불러오기

# 데이터 불러오기
raw_welfare <- read.spss(file = "Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T)

# 복사본 만들기
welfare <- raw_welfare
welfare

# 데이터 검토하기
head(welfare)
tail(welfare)
View(welfare)
dim(welfare)         # 16664행 957열 
str(welfare)
summary(welfare)

# 변수명 바꾸기 
welfare <- rename(welfare,
                  sex = h10_g3, # 성별
                  birth = h10_g4, # 태어난 연도
                  marriage = h10_g10, # 혼인 상태
                  religion = h10_g11, # 종교
                  income = p1002_8aq1, # 월급
                  code_job = h10_eco9, # 직종 코드
                  code_region = h10_reg7) # 지역 코드

#----------------------------------------------------
# 1. 성별에 따른 월급 차이
# - "성별에 따라 월급이 다를까?"

# 변수 검토하기
class(welfare$sex)
# "numeric"

table(welfare$sex)
# 1     2 
# 7578  9086 

# 이상치 확인
table(welfare$sex)

# 이상치 결측 처리
welfare$sex <- ifelse(welfare$sex==9, NA,welfare$sex)

# 결측치 확인
table(is.na(welfare$sex))

# 성별 항목 이름 부여
welfare$sex <- ifelse(welfare$sex == 1, "male", "female")
table(welfare$sex)
# female   male 
# 9086     7578 

# 성별 빈도 그래프 
qplot(welfare$sex)


# 월급 변수 검토하기
class(welfare$income)
# "numeric"

table(welfare$income)

summary(welfare$income)

# 월급 빈도 그래프 
qplot(welfare$income)

qplot(welfare$income) + xlim(0,1000)


# 이상치 결측 처리
welfare$income <- ifelse(welfare$income %in% c(0, 9999), NA, welfare$income)

# 결측치 확인
table(is.na(welfare$income))
# FALSE  TRUE 
# 4620   12044

# 성별에 따른 월급 차이 분석하기
# 1. 성별 월급 평균표 만들기
sex_income <- welfare %>% 
              filter(!is.na(income)) %>%    # 결측치 제거 
              group_by(sex) %>% 
              summarise(mean_income=mean(income))
sex_income
# sex    mean_income
# female        163.
# male          312.

# 그래프 그리기 
ggplot(data = sex_income, aes(x = sex, y = mean_income)) + geom_col()


#-----------------------------------------------------------
#2. 나이와 월급의 관계
# - "몇 살 때 월급을 가장 많이 받을까?"

# 변수 검토하기
class(welfare$birth)
# "numeric"

summary(welfare$birth)

qplot(welfare$birth)

# 전처리
# 결측치 확인
table(is.na(welfare$birth))

# 이상치 결측 처리
welfare$birth <- ifelse(welfare$birth==9999,NA,welfare$birth)
table(is.na(welfare$birth))

# 파생변수 만들기 - 나이
welfare$age <- 2015 - welfare$birth + 1
summary(welfare$age)

# 나이 빈도 그래프 
qplot(welfare$age)

# 나이와 월급의 관계 분석하기
# 나이에 따른 월급 평균표 만들기
age_income <- welfare %>% 
              filter(!is.na(income)) %>%  # 결측치 제거 
              group_by(age) %>% 
              summarise(mean_income=mean(income))

head(age_income, 10)


# 그래프로 출력 
ggplot(data = age_income, aes(x = age, y = mean_income)) + geom_line()

#--------------------------------------------------------------
# 3.연령대에 따른 월급 차이
# - "어떤 연령대의 월급이 가장 많을까?"
# 0  ~ 29 : young
# 30 ~ 59 : middle
# 60이상  : old


# 파생변수 만들기 - 연령대
welfare <- welfare %>%
  mutate(ageg = ifelse(age < 30, "young",
                       ifelse(age <= 59, "middle", "old")))

# 각 연령대 빈도수 
table(welfare$ageg)
# middle    old    young 
# 6049      6281   4334 

#  빈도 그래프
qplot(welfare$ageg)

# 연령대에 따른 월급 차이 분석하기
# 연령대별 월급 평균표 만들기
ageg_income <- welfare %>% 
               filter(!is.na(income)) %>%  # 결측치 제거 
               group_by(ageg) %>% 
               summarise(mean_income=mean(income))
ageg_income
# ageg         mean_income
# middle        282.
# old           125.
# young         164.

# 그래프 그리기 
ggplot(data=ageg_income, aes(x=ageg, y=mean_income)) +
  geom_col() +
  scale_x_discrete(limits=c("young","middle","old"))


#--------------------------------------------------------
# 4.연령대 및 성별 월급 차이
# - "성별 월급 차이는 연령대별로 다를까

# 연령대 및 성별 월급 차이 분석하기
# 연령대 및 성별 월급 평균표 만들기

sex_income <- welfare %>% 
              filter(!is.na(income)) %>%  # 결측치 제거 
              group_by(ageg, sex) %>% 
              summarise(mean_income=mean(income))
sex_income
# ageg   sex          mean_income
# middle female       188. 
# middle male         353. 
# old    female       81.5
# old    male         174. 
# young  female       160. 
# young  male         171. 


# 그래프 그리기 
ggplot(data = sex_income, aes(x = ageg, y = mean_income,                               fill = sex)) +
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old"))

# 성별 막대 분리
ggplot(data = sex_income, aes(x = ageg, 
                              y = mean_income, 
                              fill = sex)) +
  geom_col(position = "dodge") +
  scale_x_discrete(limits = c("young", "middle", "old"))


# 나이 및 성별 월급 차이 분석하기
# 성별 연령별 월급 평균표 만들기
sex_age <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age, sex) %>%
  summarise(mean_income = mean(income))

head(sex_age)

# 그래프 그리기
ggplot(data = sex_age,aes(x=age,y=mean_income,col=sex)) + geom_line()


#---------------------------------------------------------
# 5. 직업별 월급 차이
# - "어떤 직업이 월급을 가장 많이 받을까?"

# 1. 변수 검토하기
class(welfare$code_job)

table(welfare$code_job)

# 2. 전처리
# 직업분류코드 목록 불러오기
library(readxl)
list_job <- read_excel("Koweps_Codebook.xlsx", 
                       col_names = T, sheet = 2)
head(list_job)
# code_job job                                
# <dbl> <chr>                              
# 1      111 의회의원 고위공무원 및 공공단체임원
# 2      112 기업고위임원                       
# 3      120 행정 및 경영지원 관리자            
# 4      131 연구 교육 및 법률 관련 관리자      
# 5      132 보험 및 금융 관리자                
# 6      133 보건 및 사회복지 관련 관리자 

dim(list_job)     # 149행   2열 


# welfare와 list_job 데이터 프레임 합치기
welfare <- left_join(welfare, list_job, id="code_job")

welfare %>% filter(!is.na(code_job)) %>%  # 결측치 제거 
            select(code_job, job) %>% 
            head(10)

# 직업별 월급 차이 분석하기
# 직업별 월급 평균표 만들기
job_income <- welfare %>% 
              filter(!is.na(job) & !is.na(income)) %>%  #결측치제거
              group_by(job) %>% 
              summarise(mean_income=mean(income))
head(job_income)

# 월급을 많이 받는 상위 10개의 직업을 구하자. : 내림차순 정렬 
top10 <- job_income %>% 
         arrange(desc(mean_income)) %>% 
         head(10)
top10

# 그래프 그리기 
ggplot(data = top10, aes(x = reorder(job, mean_income), 
                         y = mean_income)) +
  geom_col() +
  coord_flip()


# 하위 10위 직업 추출 : 오름차순 정렬 
bottom10 <- job_income %>%
            arrange(mean_income) %>%
            head(10)
bottom10

# 그래프 만들기
ggplot(data = bottom10, aes(x = reorder(job, -mean_income),
                            y = mean_income)) +
  geom_col() +
  coord_flip() +
  ylim(0, 850)


#------------------------------------------------------------
# 6.성별 직업 빈도
# - "성별로 어떤 직업이 가장 많을까?"

# 성별 직업 빈도 분석하기
# 성별 직업 빈도표 만들기
# 남성 직업 빈도 상위 10 개 추출

job_male <- welfare %>% 
            filter(!is.na(job) & sex == "male") %>% 
            group_by(job) %>% 
            summarise(n=n()) %>% 
            arrange(desc(n)) %>% 
            head(10)
job_male

# 여성 직업 빈도 상위 10 개 추출
job_female <- welfare %>%
              filter(!is.na(job) & sex == "female") %>%
              group_by(job) %>%
              summarise(n = n()) %>%
              arrange(desc(n)) %>%
              head(10)
job_female

# 그래프 만들기
# 남성 직업 빈도 상위 10 개 직업
ggplot(data = job_male, aes(x = reorder(job, n), y = n)) +
      geom_col() +
      coord_flip()

# 여성 직업 빈도 상위 10 개 직업
ggplot(data = job_female, aes(x = reorder(job, n), y = n)) +
      geom_col() +
      coord_flip()

#---------------------------------------------------------

# 7.종교 유무에 따른 이혼율
# - 종교가 있는 사람들이 이혼을 덜 할까?

# 종교 변수 검토 및 전처리하기
# 변수 검토하기
class(welfare$religion)

table(welfare$religion)
#    1    2 
# 8047 8617 

# 전처리
# 종교 유무 이름 부여
welfare$religion <-ifelse(welfare$religion==1,"yes","no")
table(welfare$religion)

# 종교 유.무 빈도 그래프 출력
qplot(welfare$religion)


# 혼인 상태 변수 검토 및 전처리하기
# 1. 변수 검토하기
class(welfare$marriage)

# 빈도수 
# 0: 비해당(18세미만), 1:유배우자, 2:사별, 3:이혼
# 4: 별거, 5:미혼(18세이상, 미혼모 포함), 6:기타(사망 등)
table(welfare$marriage)
# 0    1    2     3     4    5    6 
# 2861 8431 2117  712   84 2433   26 


# 이혼 여부 변수 생성하기
welfare$group_marriage <- ifelse(welfare$marriage == 1,                                        "marriage",
                          ifelse(welfare$marriage == 3,                                       "divorce", NA))

table(welfare$group_marriage)

# 결측치 확인
table(is.na(welfare$group_marriage))
# FALSE  TRUE 
# 9143   7521 

qplot(welfare$group_marriage)


# 종교 유무에 따른 이혼율 분석하기
# 1. 종교 유무에 따른 이혼율 표 만들기
religion_marriage <- welfare %>%
               filter(!is.na(group_marriage)) %>%
               group_by(religion, group_marriage) %>%
               summarise(n = n()) %>%
               mutate(tot_group = sum(n)) %>%
               mutate(pct = round(n/tot_group*100, 1))

religion_marriage
# religion group_marriage     n   tot_group   pct

# 1 no       divorce          384      4602   8.3
# 2 no       marriage        4218      4602  91.7
# 3 yes      divorce          328      4541   7.2
# 4 yes      marriage        4213      4541  92.8
    
# 2. 이혼율 표 만들기
# 이혼 추출
divorce <- religion_marriage %>%
           filter(group_marriage == "divorce") %>%
           select(religion, pct)
divorce
# religion     pct
# 1 no         8.3
# 2 yes        7.2

# 3. 그래프 만들기
ggplot(data = divorce, aes(x = religion, y = pct)) + 
  geom_col()



#연령대 및 종교 유무에 따른 이혼율 분석하기
# 1. 연령대별 이혼율 표 만들기
ageg_marriage <- welfare %>%
  filter(!is.na(group_marriage)) %>%
  group_by(ageg, group_marriage) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100, 1))

ageg_marriage


# 연령대별 이혼율 그래프 만들기
# 초년 제외, 이혼 추출
ageg_divorce <- ageg_marriage %>%
  filter(ageg != "young" & group_marriage == "divorce") %>%
  select(ageg, pct)

ageg_divorce
# ageg       pct

# 1 middle   8.9
# 2 old      6.6

# 그래프 만들기
ggplot(data = ageg_divorce, aes(x = ageg, y = pct)) + 
     geom_col()


# 연령대 및 종교 유무에 따른 이혼율 표 만들기
# 연령대, 종교유무, 결혼상태별 비율표 만들기
ageg_religion_marriage <- welfare %>%
  filter(!is.na(group_marriage) & ageg != "young") %>%
  group_by(ageg, religion, group_marriage) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100, 1))

ageg_religion_marriage
# ageg   religion group_marriage     n tot_group    pct

# 1 middle no       divorce          260      2681   9.7
# 2 middle no       marriage        2421      2681  90.3
# 3 middle yes      divorce          177      2237   7.9
# 4 middle yes      marriage        2060      2237  92.1
# 5 old    no       divorce          123      1884   6.5
# 6 old    no       marriage        1761      1884  93.5
# 7 old    yes      divorce          150      2281   6.6
# 8 old    yes      marriage        2131      2281  93.4

# 연령대 및 종교 유무별 이혼율 표 만들기
df_divorce <- ageg_religion_marriage %>%
              filter(group_marriage == "divorce") %>%
              select(ageg, religion, pct)
df_divorce
# ageg    religion    pct

# 1 middle no         9.7
# 2 middle yes        7.9
# 3 old    no         6.5
# 4 old    yes        6.6

# 연령대 및 종교 유무에 따른 이혼율 그래프 만들기
ggplot(data = df_divorce, aes(x = ageg, y = pct, 
                              fill = religion )) +
  geom_col(position = "dodge")


#-----------------------------------------------------------
# 지역별 연령대 비율
# - "노년층이 많은 지역은 어디일까?"

# 지역 변수 검토 및 전처리하기
# 1. 변수 검토하기
class(welfare$code_region)

table(welfare$code_region)
# 1    2    3    4    5    6    7 
# 2486 3711 2785 2036 1467 1257 2922 


# 2. 전처리
# 1:서울, 2:수도권(인천,경기), 3:부산/경남/울산
# 4:대구/경북 5:대전/충남 6:강원/충북 7:광주/전남/전북/제주도 
# 지역 코드 목록 만들기
list_region <- data.frame(code_region = c(1:7),
                          region = c("서울",
                                     "수도권(인천/경기)",
                                     "부산/경남/울산",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주도"))
list_region

# welfare와 list_region  데이터 프레임 합치기
welfare <- left_join(welfare, list_region, id = "code_region")

welfare %>% select(code_region, region) %>% 
            head()


# 지역별 연령대 비율 분석하기
# 1. 지역별 연령대 비율표 만들기
region_ageg <- welfare %>%
          group_by(region, ageg) %>%
          summarise(n = n()) %>%
          mutate(tot_group = sum(n)) %>%
          mutate(pct = round(n/tot_group*100, 2))
head(region_ageg)
# region                ageg       n tot_group   pct

# 1 강원/충북             middle   417      1257  33.2
# 2 강원/충북             old      555      1257  44.2
# 3 강원/충북             young    285      1257  22.7
# 4 광주/전남/전북/제주도 middle   947      2922  32.4
# 5 광주/전남/전북/제주도 old     1233      2922  42.2
# 6 광주/전남/전북/제주도 young    742      2922  25.4

# 2. 그래프 만들기
ggplot(data = region_ageg, aes(x = region, y = pct, 
                               fill = ageg)) +
  geom_col() +
  coord_flip()