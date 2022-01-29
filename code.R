library(tidyverse)
library(phonfieldwork)

# create_viewer ------------------------------------------------------------
setwd("/home/agricolamz/work/articles/2022_reproducibility_german/osfstorage-archive/production/trial-lists")
trial_lists <- map_dfr(list.files(), read_csv)
setwd("../../../hw3")


trial_lists %>% 
  filter(condition == "NF") %>% 
  arrange(speaker, trial) %>% 
  group_by(speaker, colour_en, object_en) %>% 
  mutate(trial_number = 1:n()) %>% 
  mutate(researcher = case_when(colour_en == "yellow" ~ "Anya",
                                colour_en == "orange" ~ "Garik",
                                colour_en == "red" ~ "Margaux",
                                colour_en == "green" ~ "Sasha",
                                colour_en == "brown" & speaker %in% c("LG", "MS", "IP", "JB", "PS", "PB", "CG") ~ "Anya",
                                colour_en == "brown" & speaker %in% c("KM", "IB", "EM", "HA", "JW_3", "TS", "CT", "IS") ~ "Garik",
                                colour_en == "brown" & speaker %in% c("JN", "CO", "AL", "MZ", "HW", "CH", "JR", "VS") ~ "Margaux",
                                colour_en == "brown" & speaker %in% c("AS", "HS", "JH", "JK", "JW_2", "LM", "TB") ~ "Sasha")) %>% 
  select(researcher, speaker, trial, colour_en, object_en, trial_number) ->
  for_viewer

write_csv(for_viewer, "hw3_form.csv")

create_viewer(audio_dir = "audio", table = for_viewer, output_dir = getwd(), 
              output_file = "index")

beepr::beep()
