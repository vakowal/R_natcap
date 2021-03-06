# check out output from stocking density test
# what is the relationship between stocking density, aboveground and belowground
# biomass, and water in the soil and leaving the soil?

library(ggplot2)
library(grid)

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
print_theme <- theme(strip.text.y=element_text(size=9), 
                     strip.text.x=element_text(size=9), 
                     axis.title.x=element_text(size=9), 
                     axis.title.y=element_text(size=9),
                     axis.text=element_text(size=9),
                     plot.title=element_text(size=9, face="bold"),
                     legend.text=element_text(size=9),
                     legend.title=element_text(size=9)) + theme_bw()
outdir <- "C:/Users/Ginger/Dropbox/NatCap_backup/Forage_model/CENTURY4.6/Output/Stocking_density_test/sustainable_limit_test/figures"

sum_csv = "C:/Users/Ginger/Dropbox/NatCap_backup/Forage_model/CENTURY4.6/Output/Stocking_density_test/sustainable_limit_test/empirical_precip/summary.csv"
sumdf = read.csv(sum_csv)
sumdf$stocking_density_f = as.factor(sumdf$stocking_density)
sumdf$date_f = as.factor(sumdf$date)
sumdf$below_biomass_kg_ha <- sumdf$below_biomass_gm2 * 10
sumdf$root_shoot <- sumdf$above_total_biomass_kg_ha / sumdf$below_biomass_kg_ha

sd_levels = c(levels(sumdf$stocking_density_f)[1],
                  levels(sumdf$stocking_density_f)[4],
                  levels(sumdf$stocking_density_f)[7],
                  levels(sumdf$stocking_density_f)[10])
subset <- sumdf[which(sumdf$stocking_density_f %in% sd_levels), ] 
# or
subset <- sumdf[which(sumdf$stocking_density <= 3.17535),]

# is lower biomass associated with greater water in soil profile?
subset <- sumdf[which(sumdf$date == 2015.42), ]
subset$avail_h2o_illus <- subset$h2o_avail_cm * 100
p <- ggplot(subset, aes(x=stocking_density, y=avail_h2o_illus))
p <- p + geom_line(aes(colour="water accessible by plants (* 100)"))
p <- p + geom_line(aes(x=stocking_density, y=below_biomass_kg_ha, color="belowground biomass"))
p <- p + geom_line(aes(x=stocking_density, y=above_total_biomass_kg_ha, color="aboveground biomass"))
p <- p + scale_color_manual(values=c("water accessible by plants (* 100)"=cbPalette[1], 
                                     "belowground biomass"=cbPalette[2],
                                     "aboveground biomass"=cbPalette[3]))
p <- p + xlab("stocking density (animals/ha)") + ylab("biomass (kg/ha)")
p <- p + print_theme + theme(legend.key = element_blank(), legend.title=element_blank())
pngname <- paste(outdir, "Biomass vs available h2o.png", sep="/")
png(file=pngname, units="in", res=300, width=7, height=4)
print(p)
dev.off()

# examine biomass, above- and below-ground, and water variables
# at different stocking density levels
p <- ggplot(subset, aes(x=date, y=precip_cm))
p <- p + geom_line(aes(colour="precipitation"))
p <- p + geom_line(aes(x=date, y=h2o_avail_cm, colour="accessible by plants"))
p <- p + geom_line(aes(x=date, y=h2o_deep_storage_cm, colour="deep storage"))
p <- p + geom_line(aes(x=date, y=stream_flow_cm, colour="stream flow"))
p <- p + scale_color_manual(values=c("precipitation"=cbPalette[1], 
                                     "accessible by plants"=cbPalette[2],
                                     "deep storage"=cbPalette[3],
                                     "stream flow"=cbPalette[4]))
p <- p + print_theme + theme(legend.key = element_blank(), legend.title=element_blank())
p <- p + ylab("Water (cm)")
p <- p + facet_wrap( ~ stocking_density_f)
p <- p + ggtitle("Soil water by stocking density (animals/ha)")
pngname <- paste(outdir, "Soil water doubled precip_sustainable_density.png", sep="/")
png(file=pngname, units="in", res=300, width=9, height=5)
print(p)
dev.off()

p <- ggplot(subset, aes(x=date, y=below_biomass_kg_ha))
p <- p + geom_line(aes(colour="belowground biomass"))
p <- p + geom_line(aes(x=date, y=above_total_biomass_kg_ha, colour="aboveground biomass"))
p <- p + scale_color_manual(values=c("belowground biomass"=cbPalette[2], 
                                     "aboveground biomass"=cbPalette[1]))
p <- p + print_theme
p <- p + theme(legend.key = element_blank(), legend.title=element_blank())
p <- p + ylab("Biomass (kg/ha)")
p <- p + facet_wrap( ~ stocking_density_f)
p <- p + ggtitle("Biomass by stocking density (animals/ha)")
pngname <- paste(outdir, "Biomass doubled precip_sustainable_density.png", sep="/")
png(file=pngname, units="in", res=300, width=9, height=5)
print(p)
dev.off()

# look at difference in biomass between empirical and doubled precip
sum_csv2 = "C:/Users/Ginger/Dropbox/NatCap_backup/Forage_model/CENTURY4.6/Output/Stocking_density_test/sustainable_limit_test/doubled_precip/summary.csv"
sumdf2 = read.csv(sum_csv2)
sumdf2$below_biomass_kg_ha <- sumdf2$below_biomass_gm2 * 10
sumdf$diff_aboveground_biomass <- sumdf2$above_total_biomass_kg_ha - sumdf$above_total_biomass_kg_ha
sumdf$diff_belowground_biomass <- sumdf2$below_biomass_kg_ha - sumdf$below_biomass_kg_ha

subset <- sumdf
p <- ggplot(subset, aes(x=date, y=diff_belowground_biomass))
p <- p + geom_line(aes(colour="difference: belowground biomass"))
p <- p + geom_line(aes(x=date, y=diff_aboveground_biomass, colour="difference: aboveground biomass"))
p <- p + scale_color_manual(values=c("difference: belowground biomass"=cbPalette[2], 
                                     "difference: aboveground biomass"=cbPalette[1]))
p <- p + print_theme
p <- p + theme(legend.key = element_blank(), legend.title=element_blank(), legend.position="bottom",
               legend.margin=unit(-0.7,"cm"))
p <- p + ylab("Difference (kg/ha)")
p <- p + facet_wrap( ~ stocking_density_f)
pngname <- paste(outdir, "Biomass_doubled_empirical_diff.png", sep="/")
png(file=pngname, units="in", res=300, width=7, height=5)
print(p)
dev.off()

# plant-available h2o is correlated with aboveground biomass, not belowground
test = cor.test(subset$above_total_biomass_kg_ha, subset$h2o_avail_cm, method="spearman")
test2 = cor.test(subset$below_biomass_kg_ha, subset$h2o_avail_cm, method="spearman")

# is there a threshold sd above which cattle lose weight?
p <- ggplot(sumdf, aes(x=date, y=animal_gain_kg,
                        group=stocking_density_f))
p <- p + geom_point(aes(colour=stocking_density_f))
p <- p + geom_line(aes(colour=stocking_density_f))
print(p)
p <- ggplot(subset, aes(x=date, y=total_offtake_kg,
                       group=stocking_density_f))
p <- p + geom_point(aes(colour=stocking_density_f))
p <- p + geom_line(aes(colour=stocking_density_f))
print(p)

# biomass varying with date
p <- ggplot(subset, aes(x=date, y=above_total_biomass_kg_ha,
                       group=stocking_density_f))
p <- p + geom_point(aes(colour=stocking_density_f))
print(p)
p <- ggplot(subset, aes(x=date, y=below_biomass_gm2,
                       group=stocking_density_f))
p <- p + geom_point(aes(colour=stocking_density_f))
print(p)

# biomass varying with stocking density
p <- ggplot(sumdf, aes(x=stocking_density, y=below_biomass_gm2,
                       group=date_f))
p <- p + geom_point(aes(colour=date_f))
print(p)  # effect of stocking density much more apparent at later dates
subset <- sumdf[which(sumdf$date_f == "2015.92"), ]
p <- ggplot(subset, aes(x=stocking_density, y=below_biomass_gm2))
p <- p + geom_point()
print(p)
p <- ggplot(subset, aes(x=stocking_density, y=above_total_biomass_kg_ha))
p <- p + geom_point()
print(p)
p <- ggplot(subset, aes(x=stocking_density, y=root_shoot))
p <- p + geom_point()
print(p)

