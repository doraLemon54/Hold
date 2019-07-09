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

# summarise(): 통계치 산출
exam %>% summarise(mean_math=mean(math),
                   sum_math=sum(math))

# group_by() : 집단별로 나누기 
exam %>% group_by(class) %>% 
         summarise(mean_math=mean(math))

exam %>% group_by(class) %>% 
         summarise(mean_math=mean(math),     # 평균 
                   sum_math=sum(math),       # 합 
                   median_math=median(math), # 중앙값 
                   n=n())                    # 빈도수 


library(ggplot2)

# ggplot2 의 mpg 데이터를 데이터프레임 형태로 불러오기
mpg <- as.data.frame(ggplot2::mpg)
mpg

head(mpg)
View(mpg)
dim(mpg)     # 234행   11열

mpg %>% group_by(manufacturer) %>%          # 회사별로 분류 
        filter(class=='suv') %>%            # suv 차량 추출 
        mutate(tot=(cty+hwy)/2) %>%         # 통합연비 
        summarise(mean_tot = mean(tot)) %>% # 통합연비의 평균
        arrange(desc(mean_tot)) %>%         # 내림차순 정렬 
        head(6)
  
#----------------------------------------------------------------
# 데이터 합치기

# 중간고사 성적
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm=c(60,80,70,90,85))
test1

# 기말고사 성적
test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(70,83,65,95,80))
test2

# 가로로 합치기 : left_join()
total <- left_join(test1, test2, by="id")
total

exam

# 각 반의 담당교사 데이터프레임 생성 
name <- data.frame(class=c(1,2,3,4,5),
                   teacher=c('kim','lee','park','choi','jung'))
name

# exam, name 데이터 프레임을 가로로 합치기 : left_join()
exam_new <- left_join(exam, name, by='class')
exam_new



# 세로로 합치기 : bind_rows()

# 1~5번 학생의 시험 성적 
group_a <- data.frame(id=c(1,2,3,4,5),
                      test=c(60,80,70,90,85))
group_a

# 6~10번 학생의 시험 성적
group_b <- data.frame(id=c(6,7,8,9,10),
                      test=c(70,83,65,95,80))
group_b

#세로로 합치기 : bind_rows()
group_all <- bind_rows(group_a, group_b)
group_all