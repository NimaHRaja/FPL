source("init.R")

hamming_similarity <-  
    DF %>% t() %>%
    hamming.distance()
hamming_similarity <- 
    (30 - hamming_similarity)/30

eigen_states <- 
    eigen(hamming_similarity)

eigen_states$values
eigen_states$vectors %>% View()
eigen_states$vectors %*% t(eigen_states$vectors) %>% View()
cor(eigen_states$vectors) %>% View()




hamming_similarity %*% eigen_states$vectors %>% View()
hamming_similarity %*% eigen_states$vectors %>% colSums()
# eigen_states$vectors %*% hamming_similarity %*% t(eigen_states$vectors) %>% View()
# hamming_similarity %*% eigen_states$vectors %>% t() %>% as.data.frame() %>% 
    # summarise(sum(`Sergio Torija`*`Costas Chori`))


results <- 
    as.matrix(DF) %*% eigen_states$vectors %>% as.data.frame()
results$player <- row.names(results)


# results <- melt(results, id.vars = "player") 
# 
# results %>% group_by(variable) %>% mutate(scale_factor = sum(value)) %>% 
#     ungroup() %>% mutate(value = value/scale_factor * 15) %>% View()





res %>% ggplot(aes(x = V2, y = V3, label = player)) + geom_text()


res %>% View()


(res %>% select(-player) %>% as.matrix()) %*% eigen_states$vectors[1,] %>% View()
