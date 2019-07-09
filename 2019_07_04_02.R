# 결측치(Missing Value)
# • 누락된 값, 비어있는 값
# • 함수 적용 불가, 분석 결과 왜곡
# • 제거 후 분석 실시

# 결측치를 가진 데이터 프레임 생성
df <- data.frame(sex=c('M','F',NA,'M','F'),
                 score=c(5,4,3,4,NA))
df

# 결측치 확인 : is.na()로 확인 
# 결측치 : TRUE 로 나타남 
is.na(df)

# 결측치 빈도수 구하기 
table(is.na(df))
# FALSE  TRUE 
#  8       2 

# sex 변수의 결측치 빈도수 구하기
table(is.na(df$sex))
# FALSE  TRUE 
# 4       1 

# score 변수의 결측치 빈도수 구하기
table(is.na(df$score))
# FALSE  TRUE 
# 4       1

# 결측치가 포함된 데이터는 정상적으로 연산이 되지 않는다. 
mean(df$score)
# NA

#-------------------------------------------------------
# 결측치 제거

library(dplyr)

# 결측치가 있는 행을 제거
# score 변수의 결측치 데이터 추출 
df %>% filter(is.na(score))

# score 변수의 결측치가 아닌 데이터 추출
df %>% filter(!is.na(score))

# 결측치가 아닌 데이터를 df_nomiss 데이터 프레임에 저장 
df_nomiss <- df %>% filter(!is.na(score))
df_nomiss

mean(df_nomiss$score)
sum(df_nomiss$score)


# sex,score 변수에 결측치가 없는 데이터 추출
df_nomiss <- df %>% filter(!is.na(sex) & !is.na(score))
df_nomiss


# 모든 결측치를 제거 
df_nomiss2 <- na.omit(df)
df_nomiss2


# 결측치를 제외하기 : na.rm = T
mean(df$score)
# NA
mean(df$score, na.rm=T)
sum(df$score, na.rm=T)

# 예. 
exam <- read.csv("csv_exam.csv")
exam

# exam 데이터프레임에 결측치를 추가 
# math 변수의 3,8,15행 데이터를 결측치로 처리 
exam[c(3,8,15),"math"] <- NA
exam

# math 변수에 결측치가 포함되어 있기 때문에 평균을 구할수 없다. 
mean(exam$math)
# NA

# 결측치를 제거하고 math변수의 평균, 합, 중앙값을 구해보자?
exam %>%  summarise(mean_math=mean(math, na.rm = T),
                  sum_math=sum(math, na.rm=T),
                  median_math=median(math, na.rm = T))


# 결측치를 평균값으로 대체하기

# math 평균값 
mean(exam$math, na.rm = T)
# 55.23529

# math 변수의 3,8,15행에 평균값(55점)으로 대체하기  
exam$math <- ifelse(is.na(exam$math), 55, exam$math)
exam

mean(exam$math)
# [1] 55.2


#--------------------------------------------------------------
# 이상치(Outlier) - 정상범주에서 크게 벗어난 값
# • 이상치 포함시 분석 결과 왜곡
# • 결측 처리 후 제외하고 분석

# 이상치 종류 예 해결 방법
# 존재할 수 없는 값 성별 변수에 3 결측 처리
# 극단적인 값 몸무게 변수에 200 정상범위 기준 정해서 결측 처리


# 이상치가 포함된 데이터 프레임 생성
# sex : 1(남자), 2(여자),  score: 1 ~ 5
outlier <- data.frame(sex=c(1,2,1,3,2,1),
                      score=c(5,4,3,4,2,6))
outlier

# 이상치 데이터 확인 
table(outlier$sex)    # 3
# 1 2 3 
# 3 2 1 

table(outlier$score)  # 6
# 2 3 4 5 6 
# 1 1 2 1 1 

# 이상치 데이터를 결측치로 처리하기
# sex가 3이면 NA로 할당 
outlier$sex <- ifelse(outlier$sex==3, NA, outlier$sex)
outlier

# score가 6이면 NA로 할당 
outlier$score <- ifelse(outlier$score >5, NA, outlier$score)
outlier

# 결측치를 제거하고, 성별(sex)로  score 변수의 평균값 구하기 
outlier %>% filter(!is.na(sex) & !is.na(score)) %>% 
            group_by(sex) %>% 
            summarise(mean_score = mean(score))


#----------------------------------------------------------
# 그래프 그리기
install.packages("ggplpot2")

library(ggplot2)

# 배경 만들기
ggplot(data=mpg, aes(x=displ, y=hwy))

# 산점도
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()


# x축 범위를 3~6, y축 범위 10~30 으로 수정 
ggplot(data=mpg, aes(x=displ, y=hwy)) + 
      geom_point() + xlim(3,6) + ylim(10,30)



#----------------------------------------------------
# 막대 그래프
library(ggplot2)
library(dplyr)

df_mpg <- mpg %>% 
          group_by(drv) %>% 
          summarise(mean_hwy=mean(hwy))
df_mpg

ggplot(data=df_mpg, aes(x=drv, y=mean_hwy)) + geom_col()


# 크기 순으로 정렬하기
#1. 작은 크기에서 큰 크기 순으로 정렬 
ggplot(data=df_mpg, aes(x=reorder(drv,mean_hwy),y=mean_hwy)) + 
      geom_col()

#2. 큰 크기에서 작은 크기 순으로 정렬 
ggplot(data=df_mpg, aes(x=reorder(drv,-mean_hwy),y=mean_hwy)) + 
      geom_col()


# 빈도 막대 그래프
ggplot(data=mpg, aes(x=drv)) + geom_bar()

ggplot(data=mpg, aes(x=hwy)) + geom_bar()


#-------------------------------------------------------------
# 선 그래프
ggplot(data=economics, aes(x=date, y=unemploy)) + geom_line()



#-------------------------------------------------------------
# 상자 그래프
ggplot(data=mpg, aes(x=drv, y=hwy)) + geom_boxplot()




