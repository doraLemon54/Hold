# CSV(Comma Separated Value) 파일 불러오기

df_csv_exam <- read.csv("csv_exam.csv")
df_csv_exam


# 데이터 프레임을 만들어서 csv파일로 저장
df_midterm <- data.frame(english=c(90,80,60,70),
                         math=c(50,60,100,20),
                         class=c(1,1,2,2))
df_midterm

write.csv(df_midterm, file="df_midterm.csv")


#----------------------------------------------
# 05-1. 데이터 파악하기
# 함수 기능
# head() 데이터 앞부분 출력
# tail() 데이터 뒷부분 출력
# View() 뷰어 창에서 데이터 확인
# dim() 데이터 차원 출력
# str() 데이터 속성 출력
# summary() 요약통계량 출력

# csv 파일 불러오기
exam <- read.csv("csv_exam.csv")
exam

# head() : 앞에서 부터 6행까지 출력
head(exam)
head(exam, 10)

# tail() : 뒤에서 부터 6행까지 출력 
tail(exam)
tail(exam, 10)

# View() : 뷰어 창에서 데이터 확인하기 
View(exam)

# dim() : 데이터가 몇행 몇열로 되어 있는지 구해줌 
dim(exam)     # 20행 5열 

# str() : 데이터의 속성을 출력 
str(exam)

# summary() : 요약 통계정보 출력 
summary(exam)


# ggplot2 패키지 설치
install.packages("ggplot2")

library(ggplot2)

# ggplot2 의 mpg 데이터를 데이터프레임 형태로 불러오기
mpg <- as.data.frame(ggplot2::mpg)
mpg

head(mpg)
tail(mpg)
View(mpg)
str(mpg)
dim(mpg)      # 234행   11열 
summary(mpg)

#--------------------------------------------------
# 변수명 변경 : rename()

install.packages("dplyr")
library(dplyr)

# 데이터 프레임 생성
df_raw <- data.frame(var1=c(1,2,1),
                     var2=c(2,3,2))
df_raw

# 복사본 데이터 프레임 생성
df_new <- df_raw
df_new

# 변수명 변경 : 변수명 var2를  v2로 수정 
df_new <- rename(df_new, v2=var2)
df_new

#---------------------------------------------
# 파생 변수 만들기 : var_sum , var_mean

df <- data.frame(var1=c(4,3,8),
                 var2=c(2,6,1))
df

# 파생 변수 생성 
df$var_sum <- df$var1 + df$var2
df

df$var_mean <- (df$var1 + df$var2)/2
df

# mpg 통합 연비를 파생변수로 생성 : total
mpg$total <- (mpg$cty + mpg$hwy)/2
head(mpg)
mean(mpg$total)     # 20.14957
summary(mpg)
hist(mpg$total)

# 합격, 불합격을 처리하기 위한 파생변수 만들기
# 통합연비가 20이상이면 pass, 20미만이면 fail
mpg$test <- ifelse(mpg$total>=20,"pass","fail")
head(mpg)

# 빈도수 구하기
table(mpg$test)
# fail pass 
# 106  128 

# 빈도 막대 그래프로 출력
library(ggplot2)
qplot(mpg$test)


# 연비 등급을 가진 파생변수 만들기 : grade
# 연비 30이상이면  A등급
# 연비 20~29       B등급
# 연비 20미만이면  C등급 
mpg$grade <- ifelse(mpg$total>=30,'A',
                    ifelse(mpg$total>=20,'B','C'))
head(mpg, 20)

# 빈도수 구하기
table(mpg$grade)
# A   B   C 
# 10 118 106 

# 빈도 막대 그래프 출력
qplot(mpg$grade)



     




