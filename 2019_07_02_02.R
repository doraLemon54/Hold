# 변수
var1 <- c(1,2,5,7,8)
var1

var2 <- c(1:5)
var2

var3 <- seq(1, 5)
var3

var4 <- seq(1, 10, by=2)
var4

var5 <- seq(1, 10, by=3)
var5

str1 <- "a"
str1

str2 <- 'text'
str2

str3 <- "Hello World"
str3

str4 <- c('a','b','c')
str4

str5 <- c('Hello','World','is','good~!!')
str5

str1+2   # 오류 발생


x <- c(1,2,3)
mean(x)      # 평균
max(x)       # 최대값
min(x)       # 최소값 

paste(str5, collapse = ",")
paste(str5, collapse = " ")


# 패키지 설치
install.packages("ggplot2")

# 패키지 로딩 
library(ggplot2)

# 여러 문자로 구성된 변수 생성
x <- c('a','a','b','c')
x

# 빈도 그래프
qplot(x)


# ggplot2의 mpg 데이터로 그래프 만들기
# data 에 mpg, x 축에 hwy 변수 지정하여 그래프 생성
qplot(data=mpg, x=hwy)



#-----------------------------------------
# 데이터 프레임

english <- c(90,80,60,70)
english

math <- c(50,60,100,20)
math

df_midterm <- data.frame(english, math)
df_midterm

class <- c(1,1,2,2)
class
df_midterm <- data.frame(english, math, class)
df_midterm


# english 의 평균
mean(df_midterm$english)

# math 의 평균
mean(df_midterm$math)


# 데이터 프레임을 한번에 만들기
df_midterm <- data.frame(english=c(90,80,60,70),
                         math=c(50,60,100,20),
                         class=c(1,1,2,2))
df_midterm


# 엑셀 파일 불러오기
install.packages('readxl')

library(readxl)

df_exam <- read_excel('excel_exam.xlsx')
df_exam <- read_excel('c:/rwork/rproject/excel_exam.xlsx')
df_exam

# 영어, 수학, 수학 점수의 평균
mean(df_exam$english)
max(df_exam$english)
min(df_exam$english)

mean(df_exam$math)
max(df_exam$math)
min(df_exam$math)

mean(df_exam$science)
max(df_exam$science)
min(df_exam$science)





