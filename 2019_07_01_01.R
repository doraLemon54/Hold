10+20

# 주석 입니다.
# 주석 단축키 : Ctrl + Shift + c
# qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqwwqwqwqwqwqddddddddddddddddddddddddddddddddddd

#숫자형
10
20+30

#문자형
'r program'
"r program"
# 변수 
# 변수명 <-  데이터
c1 <- 'r program'
c1

# 논리형
3&0
3&1
3|0
3|1
!0
!3

# factor형
a <- c('서울','부산','인천','대전','광주')
fa <- factor(a)
plot(fa)


# 날짜와 시간
Sys.Date()  #현재 시스템의 날짜정보 출력 
Sys.time()  # 현재 시스템의 날짜.시간정보 출력 
date()      # 현재 시스템의 날짜.시간정보 출력

# 두 날짜간 일수를 계산
# 문자 데이터를 날짜 데이터로 변환 :  as.Date()
d1 <- as.Date('2019-12-31')
d2 <- as.Date('2019-07-01')
d1-d2



# 변수
# :메모리상에 데이터를 저장하기 위한 기억공간 

# 변수 만드는 방법
#  변수명 <-  데이터(값)

# 변수에 정수 할당  
a <- 10
a <- 20
a

# 변수에 실수 할당
b <- 42.195
b

# 변수에 문자 할당
c <- '서울'
c <- "서울"
c

# 변수에  숫자 / 문자 2개를 저장
# c()함수는 concatenate 로, 여러 숫자(또는 문자)들을 
# 하나로 연결시키는 것을 의미
d <- 10, 20             # 오류 발생 
d <- c(10,20)
d
e <- c('서울','인천')
e

f <- c(10,20,'서울')    # 문자로 처리
f

# 변수에 연속적인 값 할당
x <- 1:5
x               # 1 2 3 4 5
y <- 10:1
y               # 10  9  8  7  6  5  4  3  2  1


# 산술 연산자 : +, -, *, /, %%(나머지), %/%(몫)
x <- 5+2
x

x<- 5-2
x

x<- 5*2
x

x <- 5/2
x              # 2.5 

x <- 5%%2      # 나머지
x

x <- 5%/%2     # 몫 
x


# 비교 연산자 : >, >=, <, <=, ==, !=
x <- 5<3
x

y <- c(10,20,30)
z <- y <= 10
z                    # TRUE FALSE FALSE


# 논리 연산자 : |, &, !
x <- TRUE
x
y <- FALSE
y

x | y       # TRUE
x & y       # FALSE

x <- 3
!x          # FALSE

isTRUE(y)   #FALSE

z <- c(TRUE, FALSE, FALSE)
z | y       # TRUE FALSE FALSE



