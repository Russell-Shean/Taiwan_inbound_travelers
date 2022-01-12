totals <- visa_categories_melt %>%
  filter(visa_type=="Total",
         year > 2010)

twenty_twenty  <- visa_categories_melt %>%
  filter(visa_type=="Total",
         year == 2020)
  
u <- mean(totals$value)
s <- sd(totals$value)

z <- (twenty_twenty$value-u)/s


pnorm(z)

visa_categories_melt %>%
  filter(visa_type!="Total",
         visa_type!="Pleasure")%>%
ggplot()+
  geom_line(aes(x=year,y=value, color=visa_type))+
  ggtitle("Inbound visitors to Taiwan stratified by visa category")+
  ylab("People Entering Taiwan")+
  scale_y_continuous(labels = comma)+  #this changes y axis format from scientific notation to commas
  labs(color="Visa Category")

