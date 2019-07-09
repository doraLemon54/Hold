# 데이터 전처리(Preprocessing) - dplyr 패키지

# 함수 기능
# filter() 행 추출
# select() 열(변수) 추출
# arrange() 정렬
# mutate() 변수 추가
# summarise() 통계치 산출
# group_by() 집단별로 나누기
# left_join() 데이터 합치기(열)
# bind_rows() 데이터 합치기(행)

library(dplyr)
exam <- read.csv("csv_exam.csv")
exam

# filter() : 조건에 맞는 데이터를 추출 

# 1반 학생들을 추출
#  %>%  : Ctrl + Shift + M
exam %>% filter(class==1)

# 2반 학생들을 추출 
exam %>% filter(class==2)

# 1반이 아닌학생들을 추출 
exam %>% filter(class != 1)

# 3반이 아닌학생들을 추출 
exam %>% filter(class != 3)

# 수학 점수가 50점을 초과한 학생 추출
exam %>% filter(math > 50)

# 수학 점수가 50점 미만 학생 추출 
exam %>% filter(math < 50)

# 영어 점수가 80점 이상인 학생 추출 
exam %>% filter(english >= 80)

# 영어 점수가 80점 이하인 학생 추출 
exam %>% filter(english <= 80)

# 1반이면서 수학 점수가 50점 이상인 학생 추출 
exam %>% filter(class==1 & math>=50)

# 2반이면서 영어 점수가 80점 이상인 학생 추출
exam %>% filter(class==2 & english>=80)

# 수학 점수가 90이상 이거나 영어 점수가 90점 이상 학생 추출 
exam %>%  filter(math>=90 | english>=90)

# 영어 점수가 90점 미만이거나 과학 점수가 50점 미만인 학생 추출
exam %>% filter(english<90 | science<50)

# 클래스가 1반 이거나, 3반 이거나, 5반인 학생 추출
exam %>% filter(class==1 | class==3 | class==5)
exam %>% filter(class %in% c(1,3,5))


# 추출한 데이터를 변수에 저장하기
class1 <- exam %>% filter(class==1)
class1

class2 <- exam %>% filter(class==2)
class2

# 1반 학생들의 수학,영어,과학 점수 평균 
mean(class1$math)
mean(class1$english)
mean(class1$science)

# 2반 학생들의 수학,영어,과학점수 평균 
mean(class2$math)
mean(class2$english)
mean(class2$science)

#-----------------------------------------------------------
# select() : 필요한 변수만 추출하기
exam

# math 변수 데이터 추출
exam %>% select(math)

# english 변수 데이터 추출
exam %>% select(english)

# class, math, english 변수 데이터 추출 
exam %>% select(class, math, english)

# math 변수 제외한 데이터 추출 
exam %>% select(-math)

# math와 english 변수를 제외한 데이터 추출 
exam %>% select(-math, -english)


# filter()함수와 select()함수 결합해서 추출 
exam %>% filter(class==1) %>% select(english)

exam %>% select(id, math) %>% head()    # 앞에서 부터 6개 출력 

exam %>% select(id, math) %>% head(10)  # 앞에서 부터 10개 출력 


#----------------------------------------------------------------
# arrange() : 오름차순 정렬 (1,2,3....)

exam

# math 점수를 기준으로 오름차순 정렬
exam %>% arrange(math) 

# math 점수를 기준으로 내림차순 정렬
exam %>% arrange(desc(math))

# class를 기준으로 오름차순 정렬하고, class가 같은 학생들은
# math  성적을 기준으로 오름차순 정렬 
exam %>% arrange(class, math)

#-------------------------------------------------------------
# mutate() : 파생변수를 추가 

exam

# 파생 변수 생성 : total
exam %>% mutate(total=math+english+science) %>% head()

exam %>% mutate(total=math+english+science,
                mean=(math+english+science)/3) %>% head()

# 파생 변수 생성 : test
# science  점수가 60점 이상이면 pass
# science  점수가 60점 미만이면 fail
exam %>% mutate(test=ifelse(science>=60,'pass','fail')) %>% 
          head()

# 파생변수(total)를 기준으로 오름차순 정렬 
exam %>% mutate(total=math+english+science) %>%
          arrange(total)







