#Gabriel Coll 
#Code to create charts for The Future of Military Engines 

library(tidyverse) 

#############################################################################################

intro_year <- read_csv("intro_year.csv")
usaf_inventory <- read_csv("usaf_inventory.csv")
engine_specs <- read_csv("engine_specs.csv")
generation <- read_csv("generation.csv")
relevance <- read_csv("relevance.csv")

intro_year <- intro_year %>% 
  .[-1, ] %>% 
  gather(aircraft, intro_year, -year) %>% 
  .[ , -1] 

usaf_inventory[is.na(usaf_inventory)] <- 0

usaf_inventory <- gather(usaf_inventory, aircraft, amount, -year)

engine <- usaf_inventory %>% 
  inner_join(engine_specs, by = "aircraft") %>% 
  left_join(intro_year, by = "aircraft")

write.csv(engine, "engine.csv")

#############################################################################################

engine$amount <- as.integer(as.character(engine$amount))
engine$intro_year <- as.integer(as.character(engine$intro_year))

engine <- engine %>% 
  mutate(age = year - intro_year) 

by_total <- engine %>% 
  group_by(year) %>% 
  summarise(total = sum(amount, na.rm = TRUE))

engine <- engine %>% 
  left_join(by_total, by = "year") %>% 
  mutate(total_age = amount * age / total)

by_total <- engine %>% 
  group_by(year)
by_total <- by_total %>% 
  summarise(total_age = sum(total_age, na.rm = TRUE))

p_total_age <- ggplot(data = by_total) + 
  geom_area(aes(y = total_age, x = year), stat = "identity", fill = "#566377") + 
  theme_fivethirtyeight() + 
  ggtitle("Average platform age of the USAF inventory, 1950-present") 
p_total_age

#############################################################################################

by_type <- engine %>% 
  group_by(year, engine_type)
by_type <- by_type %>% 
  filter(engine_type %in% c("Radial", 
                            "Turbofan",
                            "Turbojet",
                            "Turboprop",
                            "Turboshaft")) %>%
  summarise(amount = sum(amount, na.rm = TRUE)) 

p_type <- ggplot(data = by_type) +
  geom_area(aes(y = amount, x = year, fill = engine_type), stat = "identity") + 
  theme_fivethirtyeight() + 
  ggtitle("USAF inventory amount by engine type") 

p_type

#############################################################################################

engine <- engine %>% 
  left_join(generation, by = "aircraft")

generation <- engine %>% 
  group_by(aircraft, intro_year, relevance, generation) %>% 
  summarise(peak_inventory = mean(peak_inventory, na.rm = TRUE)) %>% 
  filter(generation != "Other")

p_peak_inventory_generation <- ggplot(data = generation) + 
  geom_point(mapping = aes(x = intro_year, y = peak_inventory, color = generation, shape = relevance), size = 3) +
  # facet_wrap( ~ generation, nrow = 3) + 
  theme_fivethirtyeight() + 
  ggtitle("Peak inventory and introduction year for fighter/attack, by generation") 

p_peak_inventory_generation

#############################################################################################

inventory <- engine %>% 
  filter(relevance != "Old") %>% 
  group_by(aircraft, intro_year, relevance, generation, type, engine_type) %>% 
  summarise(peak_inventory = mean(peak_inventory, na.rm = TRUE))   

ggplot(data = inventory) + 
  geom_point(mapping = aes(x = intro_year, y = peak_inventory, color = relevance)) +
  facet_wrap( ~ type, nrow = 3) +
  theme_fivethirtyeight()

ggplot(data = inventory) + 
  geom_point(mapping = aes(x = intro_year, y = peak_inventory, color = relevance)) +
  facet_grid(engine_type ~ type) +
  theme_fivethirtyeight()

#############################################################################################

inventory_2 <- inventory %>% 
  group_by(aircraft, intro_year) %>% 
  summarise(peak_inventory = mean(peak_inventory, na.rm = TRUE))

ggplot(data = inventory_2) + 
  geom_point(mapping = aes(x = intro_year, y = peak_inventory)) +
  geom_smooth(mapping = aes(x = intro_year, y = peak_inventory))

inventory_3 <- inventory_2 %>% 
  filter(peak_inventory >= 30)

ggplot(data = inventory_3) + 
  geom_point(mapping = aes(x = intro_year, y = peak_inventory)) +
  geom_smooth(mapping = aes(x = intro_year, y = peak_inventory))

#############################################################################################

inventory_total <- engine %>% 
  group_by(year) %>% 
  summarise(amount = sum(amount, na.rm = TRUE))

p_total <- ggplot() + geom_area(aes(y = amount, x = year), data = inventory_total,
                                stat="identity")
p_total

inventory_type <- engine %>% 
  group_by(year, type) %>% 
  summarise(amount = sum(amount, na.rm = TRUE))

p_type <- ggplot() + 
  geom_area(aes(y = amount, x = year), data = inventory_type, stat="identity") + 
  facet_wrap(~ type, nrow = 3) + 
  theme_fivethirtyeight()

p_type 

inventory_engine_type <- engine %>% 
  group_by(year, engine_type) %>% 
  summarise(amount = sum(amount, na.rm = TRUE)) %>% 
  filter(engine_type != "NA")

p_engine_type <- ggplot() + 
  geom_area(aes(y = amount, x = year), data = inventory_engine_type, stat="identity") + 
  facet_wrap(~ engine_type, nrow = 3) + 
  theme_fivethirtyeight()

p_engine_type

p_engine_type <- ggplot() + 
  geom_area(aes(y = amount, x = year, fill = engine_type), data = inventory_engine_type, position="stack") + 
  theme_fivethirtyeight()

p_engine_type

generation <- engine %>% 
  group_by(year, generation) %>% 
  summarise(amount = sum(amount, na.rm = TRUE)) %>% 
  filter(generation != "Other")

p_generation <- ggplot() + 
  geom_area(aes(y = amount, x = year), data = generation, stat="identity") + 
  facet_wrap(~ generation, nrow = 2) + 
  theme_fivethirtyeight()

p_generation

p_generation <- ggplot() + 
  geom_area(aes(y = amount, x = year, fill = generation), data = generation, position ="stack") + 
  theme_fivethirtyeight()

p_generation

#############################################################################################

engine <- engine %>% 
  mutate(engine_amount = amount * engine_number)

p_engine <- engine %>% 
  group_by(year) %>% 
  summarise(engine_amount = sum(engine_amount, na.rm = TRUE))

p <- ggplot() + 
  geom_area(aes(y = engine_amount, x = year), data = p_engine, stat="identity")
p  

#############################################################################################

p <- engine %>% 
  group_by(year, type) %>% 
  summarise(amount = sum(engine_amount, na.rm = TRUE))

p <- ggplot(data = p) + 
  geom_area(aes(y = amount, x = year),stat="identity") + 
  facet_wrap(~ type, nrow = 3) + 
  theme_fivethirtyeight()

p 

#############################################################################################

p <- engine %>% 
  group_by(year, engine_type) %>% 
  summarise(amount = sum(engine_amount, na.rm = TRUE)) %>% 
  filter(engine_type != "NA")

p <- ggplot(data = p) + 
  geom_area(aes(y = amount, x = year, fill = engine_type), position="stack") + 
  theme_fivethirtyeight()

p 

#############################################################################################

(p <- engine %>% 
  group_by(year, generation) %>% 
  summarise(amount = sum(engine_amount, na.rm = TRUE)) %>% 
  filter(generation != "Other") %>% 
  ggplot() + 
  geom_area(aes(y = amount, x = year, fill = generation), position ="stack") + 
  theme_fivethirtyeight())

#############################################################################################

p <- engine %>% 
  group_by(year) %>% 
  summarise(total_amount = sum(amount, na.rm = TRUE))

p <- engine %>% 
  inner_join(p, by = "year") 

p2 <- engine %>% 
  group_by(year, type) %>% 
  summarise(type_amount = sum(amount, na.rm = TRUE)) 

(p3 <- p %>% 
  left_join(p2, by = c("year", "type")) %>% 
  mutate(age_weight = age * amount / total_amount) %>%
  group_by(year) %>% 
  summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
  ggplot() + 
  geom_area(aes(y = average_age, x = year), stat="identity"))

(p4 <- p %>% 
    left_join(p2, by = c("year", "type")) %>% 
    mutate(age_weight = age * amount / type_amount) %>%
    group_by(year, type) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    facet_wrap( ~ type) + 
    theme_fivethirtyeight())

#############################################################################################

p <- engine %>% 
  group_by(year) %>% 
  summarise(total_amount = sum(amount, na.rm = TRUE))

p <- engine %>% 
  inner_join(p, by = "year") 

p2 <- engine %>% 
  group_by(year, generation) %>% 
  summarise(type_amount = sum(amount, na.rm = TRUE)) 

(p <- p %>% 
    left_join(p2, by = c("year", "generation")) %>% 
    filter(generation != "Other") %>% 
    mutate(age_weight = age * amount / type_amount) %>%
    group_by(year, generation) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    facet_wrap( ~ generation) + 
    theme_fivethirtyeight())

#############################################################################################

p <- engine %>% 
  group_by(year) %>% 
  summarise(total_amount = sum(amount, na.rm = TRUE))

p <- engine %>% 
  inner_join(p, by = "year") 

p2 <- engine %>% 
  group_by(year, type) %>% 
  summarise(type_amount = sum(amount, na.rm = TRUE)) 

(p3 <- p %>% 
    left_join(p2, by = c("year", "type")) %>% 
    mutate(age_weight = age * amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p4 <- p %>% 
    left_join(p2, by = c("year", "type")) %>% 
    mutate(age_weight = age * amount / type_amount) %>%
    group_by(year, type) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    facet_wrap( ~ type) + 
    theme_fivethirtyeight())

#############################################################################################

p <- engine %>% 
  filter(type == "FighterAttack") %>%
  group_by(year) %>% 
  summarise(total_amount = sum(amount, na.rm = TRUE)) 

p <- engine %>% 
  inner_join(p, by = "year")

(p2 <- p %>% 
    mutate(age_weight = takeoff_weight * amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>%
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p2 <- p %>% 
    mutate(age_weight = speed * amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>%
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p2 <- p %>% 
    mutate(age_weight = range * amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>%
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p2 <- p %>% 
    mutate(age_weight = ceiling * amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>%
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p2 <- p %>% 
    mutate(age_weight = climb_rate * amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>%
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p3 <- p %>% 
    mutate(age_weight = thrust_weight_aircraft * amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>%
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

#############################################################################################

p <- engine %>% 
  filter(type == "FighterAttack") %>%
  filter(engine_type == "Turbojet" | engine_type == "Turbofan") %>%
  group_by(year) %>% 
  summarise(total_amount = sum(engine_amount, na.rm = TRUE))

p <- engine %>% 
  inner_join(p, by = "year")

(p2 <- p %>% 
  mutate(age_weight = thrust * engine_amount / total_amount) %>%
  group_by(year) %>% 
  summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
  ggplot() + 
  geom_area(aes(y = average_age, x = year), stat="identity") + 
  theme_fivethirtyeight())

(p2 <- p %>% 
    mutate(age_weight = pressure_ratio * engine_amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p2 <- p %>% 
    mutate(age_weight = engine_weight * engine_amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

(p2 <- p %>% 
    mutate(age_weight = thrust_weight_engine * engine_amount / total_amount) %>%
    group_by(year) %>% 
    summarise(average_age = sum(age_weight, na.rm = TRUE)) %>% 
    ggplot() + 
    geom_area(aes(y = average_age, x = year), stat="identity") + 
    theme_fivethirtyeight())

#############################################################################################

#############################################################################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(takeoff_weight = mean(takeoff_weight, na.rm = TRUE))

pTWeight <- ggplot(scatter, aes(x = intro_year, y = takeoff_weight)) + geom_point() + 
  theme_fivethirtyeight()

pTWeight
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(speed = mean(speed, na.rm = TRUE))

pMSpeed <- ggplot(scatter, aes(x = intro_year, y = speed)) + geom_point() + 
  theme_fivethirtyeight()

pMSpeed
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(range = mean(range, na.rm = TRUE))

prange <- ggplot(scatter, aes(x = intro_year, y = range)) + geom_point() + 
  theme_fivethirtyeight()

prange 
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(climb_rate = mean(climb_rate, na.rm = TRUE))

pclimb <- ggplot(scatter, aes(x = intro_year, y = climb_rate)) + geom_point() + 
  theme_fivethirtyeight()

pclimb
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(ceiling = mean(ceiling, na.rm = TRUE))

pSCeiling <- ggplot(scatter, aes(x = intro_year, y = ceiling)) + geom_point() + 
  theme_fivethirtyeight()

pSCeiling
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(thrust_weight_engine = mean(thrust_weight_engine, na.rm = TRUE))

pThrustW <- ggplot(scatter, aes(x = intro_year, y = thrust_weight_engine)) + geom_point() + 
  theme_fivethirtyeight()

pThrustW
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(thrust = mean(thrust, na.rm = TRUE))

pMThrust <- ggplot(scatter, aes(x = intro_year, y = thrust)) + geom_point() + 
  theme_fivethirtyeight()

pMThrust
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(takeoff_weight = mean(takeoff_weight, na.rm = TRUE))

pTWeight <- ggplot(scatter, aes(x = intro_year, y = takeoff_weight)) + geom_point() + 
  theme_fivethirtyeight()

pTWeight
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(pressure_ratio = mean(pressure_ratio, na.rm = TRUE))

pPR <- ggplot(scatter, aes(x = intro_year, y = pressure_ratio)) + geom_point() + 
  theme_fivethirtyeight()

pPR
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(engine_weight = mean(engine_weight, na.rm = TRUE))

pEW <- ggplot(scatter, aes(x = intro_year, y = engine_weight)) + geom_point() + 
  theme_fivethirtyeight()

pEW
###########################################
###########################################
scatter <- engine %>% 
  filter(type == "FighterAttack") %>% 
  filter(engine_type != "Radial") %>% 
  group_by(intro_year, aircraft) %>% 
  summarise(thrust_weight_aircraft = mean(thrust_weight_aircraft, na.rm = TRUE))

pTWR <- ggplot(scatter, aes(x = intro_year, y = thrust_weight_aircraft)) + geom_point() + 
  theme_fivethirtyeight()

pTWR
###########################################

