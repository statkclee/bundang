library(tidyverse)
library(httr)
library(jsonlite)

## 경기도 성남시 분당구
url <- "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByAddr/json?address=%EA%B2%BD%EA%B8%B0%EB%8F%84%20%EC%84%B1%EB%82%A8%EC%8B%9C%20%EB%B6%84%EB%8B%B9%EA%B5%AC"

request <- GET(url)

resp <- content(request, as = "text", encoding = "UTF-8")

parsed <- jsonlite::fromJSON(resp, flatten = TRUE) %>%
  data.frame() %>% as_tibble()

mask_df <- parsed %>% 
  mutate(stock = case_when(stores.remain_stat == "empty" ~ "1~0개",
                           stores.remain_stat == "few" ~ "2~29개",
                           stores.remain_stat == "some" ~ "30~99개",
                           stores.remain_stat == "plenty" ~ "100개 이상")) %>% 
  mutate(stock = factor(stock, levels=c("100개 이상", "30~99개", "2~29개", "1~0개"))) %>% 
  select(name = stores.name, address = stores.addr, lat=stores.lat, lng = stores.lng, stock)

# mask_df %>% 
#   write_csv(paste0('data/mask_', Sys.time(), ".csv"))

# mask_df %>% 
#   write_rds(paste0('data/mask_', Sys.time(), ".rds"))

mask_df %>% 
  write_csv(paste0('data/mask_', Sys.time(), ".csv"))

mask_df %>% 
  write_csv('data/mask_df.csv')


rmarkdown::render('/home/rstudio/bundang/index.Rmd', output_dir = 'docs/')

