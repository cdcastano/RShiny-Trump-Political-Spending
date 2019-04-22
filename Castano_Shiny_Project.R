library(dplyr)
library(ggplot2)
library(lubridate)
install.packages('leaflet')
install.packages('shinydashboard')

data = read.csv("propublica_trump_spending-1.csv", stringsAsFactors = FALSE)

write.csv(data, file = "propub_clean")



#Housecleaning
names(data) = tolower(names(data))
names(data$purpose) = tolower(names(data$purpose))
colnames(data)[colnames(data)=="source"] <- "Paying"
colnames(data)[colnames(data)=="property_scrubbed"] <- "Paid"

data$property[data$property == "TRUMP INTERNATIONAL HOTEL"] = "Trump International Hotel"
data$purpose_scrubbed[data$purpose_scrubbed == "Event"] = "Events"

class(data$date)
data$date = as.Date(parse_date_time(data$date, orders = c('mdy', 'dmY', 'Ymd', 'ymd')))

data = data %>% mutate(year = year(date))
data = data %>% mutate(month = month.abb[month(date)])
data$month = month.abb[data$month]

##state 
data2$state[data$state == "NY"] = "New York"
data2$state[data$state == "FL"] = "Florida"
data2$state[data$state == "IL"] = "Illinois"
data2$state[data$state == "NC"] = "North Carolina"
data2$state[data$state == "NJ"] = "New Jersey"
data2$state[data$state == "NV"] = "Nevada"
data2$state[data$state == "VA"] = "Virginia"
data2$state[data$state == "CA"] = "California"
data2$state[data$state == "HI"] = "Hawaii"
data2$state[data$state == "DC"] = "Washington DC"
data2$state[data$state == "LA"] = "Louisiana"

###Summary questions
data %>% summarise(., sum(amount / 1000000))

###WHAT DID THEY PAY FOR
whatbar = data %>% group_by(purpose_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  ggplot(aes(x = purpose_scrubbed, y = total)) + geom_bar(stat = 'identity')
whatbar

###WHO PAID:
sourcebar = data %>%
  group_by(source) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  top_n(., 5, total) %>% 
  ggplot(aes(x = source, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
sourcebar

trumpforpresident = data %>% 
  filter(source == 'Donald J. Trump for President, Inc.') %>% 
  group_by(property_scrubbed, amount) %>% 
  top_n(., 5, amount) %>% 
  ggplot(aes(x=property_scrubbed, y=amount)) +
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
trumpforpresident

###WHO DID THEY PAY?
travelbar = data %>% filter(purpose_scrubbed == 'Travel') %>% 
  select(Paid, amount) %>% 
  group_by(Paid) %>% 
  summarise(total = sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = Paid, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
travelbar

rentbar = data %>% filter(purpose_scrubbed == 'Rent') %>% 
  group_by(property_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = property_scrubbed, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
rentbar

payrollbar = data %>% filter(purpose_scrubbed == 'Payroll') %>% 
  group_by(property_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = property_scrubbed, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
payrollbar

otherbar = data %>% filter(purpose_scrubbed == 'Other') %>% 
  group_by(property_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = property_scrubbed, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
otherbar 

lodgingbar = data %>% filter(purpose_scrubbed == 'Lodging') %>% 
  group_by(property_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = property_scrubbed, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
lodgingbar

legalbar = data %>% filter(purpose_scrubbed == 'Legal') %>% 
  group_by(property_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = property_scrubbed, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
legalbar

foodbar = data %>% filter(purpose_scrubbed == 'Food') %>% 
  group_by(property_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = property_scrubbed, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
foodbar

eventbar = data %>% filter(purpose_scrubbed == 'Event') %>% 
  group_by(property_scrubbed) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  arrange(desc(total)) %>% 
  ggplot(aes(x = property_scrubbed, y = total)) + 
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
eventbar

###WHEN did they pay it?
yearbar = data %>% 
  mutate(month_ = month(date)) %>% 
  group_by(year, month_) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  ggplot(aes(x = year, y = total)) + geom_bar(stat = 'identity')
yearbar

monthbar = data %>% 
  mutate(month = month(date)) %>% 
  group_by(month) %>% 
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>% 
  ggplot(aes(x = month, y = total)) + geom_bar(stat = 'identity')
monthbar

monthline = data %>% filter(year == 2016) %>% 
  group_by(month, amount) %>% 
  ggplot(aes(x = month, y = amount)) +
  geom_line(aes(color = 'property_scraped'))
monthline  

###WHERE did they pay?
wherebar = data %>% group_by(state) %>%
  summarise(total = sum(amount, na.rm = TRUE)/1000000) %>%
  ggplot(aes(x=state, y=total)) + geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
wherebar

statetotal = data2 %>% 
  select(amount, state) %>% 
  filter(state %in% c("New York", "Nevada", "Florida", "Illinois", 
                                 "North Carolina", "New Jersey", "Virginia", "California", 
                                 "Hawaii", "Washington DC", "Louisiana")) %>% 
  group_by(state) %>% 
  summarise(total = sum(amount, na.rm = TRUE))


