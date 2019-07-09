# 힙합 가사 텍스트 마이닝
# 텍스트 마이닝 준비하기

# 패키지 설치

# 패키지 로드
library(rJava)
library(memoise)
library(KoNLP)
library(dplyr)

# java 폴더 경로 설정
Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_211/")

# 사전 설정하기
useNIADic()

# 데이터 준비
# 데이터 불러오기
txt <- readLines("hiphop.txt")
txt

#특수 문자 제거
install.packages("stringr")
library(stringr)

# 특수 문자를 공백으로 수정 
txt <- str_replace_all(txt, "\\W"," ")

# 명사 추출
nouns <- extractNoun(txt)
nouns

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))
wordcount

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word


# 변수명 수정 :  Var1 -> word, Freq -> freq
df_word <- rename(df_word, 
                  word = Var1,
                  freq = Freq)
head(df_word)

# 2글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)
df_word

# 빈도수가 높은 단어 상위 20개 추출
top20 <- df_word %>% 
         arrange(desc(freq)) %>%    # 내림차순 정렬 
         head(20)
top20


# 워드 클라우스 만들기
# 패키지 설치
install.packages("wordcloud")

# 패키지 로딩
library(wordcloud)
library(RColorBrewer)

# 단어 색상 목록 생성
pal <- brewer.pal(8,"Dark2")
#pal <- brewer.pal(9,"Blues")
pal

# 난수 고정
set.seed(1234)

# 워드 클라우드 만들기
wordcloud(word = df_word$word,       # 단어 
          freq = df_word$freq,       # 빈도 
          min.freq = 2,              # 최소 2단어 이상 
          max.words = 200,           # 최대 표현 단어수 
          random.order = F,          # 고빈도 단어를 중앙배치
          rot.per = .1,              # 회전 단어 비율 
          scale = c(3, 0.2),         # 단어 크기 범위 : 원모양 
          colors = pal
          )


#----------------------------------------------
# 국정원 트윗 텍스트 마이닝
# • 국정원 계정 트윗 데이터

# 데이터 로드
twitter <- read.csv("twitter.csv",
                    header = T,
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8")
twitter

# 변수명 수정
twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용)
twitter

# 특수 문자 제거
twitter$tw <- str_replace_all(twitter$tw,"\\W"," ")
head(twitter$tw)

# 명사 추출
nouns <- extractNoun(twitter$tw)
nouns

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도수 구하기 
wordcount <- table(unlist(nouns))
wordcount

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word
head(df_word)

# 변수명 수정 : Var1 -> word, Freq -> freq
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)
head(df_word)

# 2글자 이상의 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)
df_word

# 빈도수가 높은 상위 20개 단어 추출
top20 <- df_word %>% 
         arrange(desc(freq)) %>%  # 빈도수 기준으로 내림차순 정렬 
         head(20)
top20


# 단어 빈도 막대 그래프 만들기
library(ggplot2)


ggplot(data=top20, aes(x=word, y=freq)) + 
      geom_col()


# 워드 클라우드 만들기

# 색상 목록 만들기
pal <- brewer.pal(8,"Dark2")
#pal <- brewer.pal(9,"Blues")
pal

#난수 고정
set.seed(1234)

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 10,
          max.words = 200,
          random.order = F,
          rot.per = .1,
          scale = c(6, 0.2),
          colors = pal
          )

#--------------------------------------

install.packages("KoNPL")
install.packages("RColorBrewer")
install.packages("wordcloud")

setwd("d:/rwork/rpro")
install.packages("KoNLP")
library(KoNLP)
library(wordcloud)
txt <- readLines("hong.txt")
txt<-gsub("저","",txt)
txt<-gsub("수","",txt)
txt<-gsub("들","",txt)

nouns <- sapply
