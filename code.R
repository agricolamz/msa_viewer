setwd("/home/agricolamz/work/articles/2022_reproducibility_german/hw2")
library(tidyverse)
library(phonfieldwork)

# extract audio chunks -----------------------------------------------------
dir.create("audio")

txtgrids <- list.files("../osfstorage-archive/production/audio", 
                       pattern = ".TextGrid", full.names = TRUE)

audio <- list.files("../osfstorage-archive/production/audio", 
                       pattern = ".wav", full.names = TRUE)

names <- list.files("../osfstorage-archive/production/audio", 
                    pattern = ".wav")
names <- str_c(str_remove_all(names, ".wav"), "_")

lapply(seq_along(audio), function(i){
  extract_intervals(file_name = normalizePath(audio[i]),
                    textgrid = normalizePath(txtgrids[i]),
                    prefix = names[i],
                    tier = 4,
                    path = "audio")  
})

# merge all trial_lists ----------------------------------------------------
setwd("../osfstorage-archive/production/trial-lists")
trial_lists <- map_dfr(list.files(), read_csv)

# rename files -------------------------------------------------------------
setwd("../../../hw2")
trial_lists %>% 
  arrange(speaker, trial) %>% 
  mutate(typicality = ifelse(is.na(typicality), "", typicality),
         new_names = str_c(speaker, "_", trial, "_", condition, "_", typicality, 
                           "_", colour_en, "_", object_en)) %>% 
  pull(new_names) %>% 
  rename_soundfiles(path = "audio", backup = FALSE, autonumbering = FALSE, 
                    logging = FALSE)

# remove files -------------------------------------------------------------
file.remove(list.files("audio", pattern = "_AF_", full.names = TRUE))
file.remove(list.files("audio", pattern = "_ANF_", full.names = TRUE))

# create_viewer ------------------------------------------------------------
trial_lists %>% 
  filter(condition == "NF") %>% 
  arrange(speaker, trial) %>% 
  group_by(speaker, colour_en, object_en) %>% 
  mutate(trial_number = 1:n()) %>% 
  select(speaker, trial, colour_en, object_en, trial_number) ->
  for_viewer

create_viewer(audio_dir = "audio", table = for_viewer)
