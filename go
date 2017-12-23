#!/bin/csh
./tri_run \
	/scratch/group/csce435/Matrix/ssget/Mallya/lhr71_adj.tsv \
	/scratch/group/csce435/Matrix/ssget/Freescale/Freescale2_adj.tsv \
	/scratch/group/csce435/Matrix/snap/cit-HepPh/cit-HepPh_adj.tsv \
	/scratch/group/csce435/Matrix/snap/cit-HepTh/cit-HepTh_adj.tsv \
	/scratch/group/csce435/Matrix/snap/email-EuAll/email-EuAll_adj.tsv \
	/scratch/group/csce435/Matrix/snap/soc-Epinions1/soc-Epinions1_adj.tsv \
	/scratch/group/csce435/Matrix/snap/soc-Slashdot0811/soc-Slashdot0811_adj.tsv \
	/scratch/group/csce435/Matrix/snap/soc-Slashdot0902/soc-Slashdot0902_adj.tsv \
	/scratch/group/csce435/Matrix/snap/amazon0302/amazon0302_adj.tsv \
	/scratch/group/csce435/Matrix/snap/amazon0312/amazon0312_adj.tsv \
	/scratch/group/csce435/Matrix/snap/amazon0505/amazon0505_adj.tsv \
	/scratch/group/csce435/Matrix/snap/amazon0601/amazon0601_adj.tsv \
	/scratch/group/csce435/Matrix/snap/flickrEdges/flickrEdges_adj.tsv \
	/scratch/group/csce435/Matrix/snap/cit-Patents/cit-Patents_adj.tsv \
	/scratch/group/csce435/Matrix/ssget/SNAP/soc-LiveJournal1_adj.tsv \
	/scratch/group/csce435/Matrix/ssget/Gleich/wb-edu_adj.tsv \
	/scratch/group/csce435/Matrix/snap/as-caida20071105/as-caida20071105_adj.tsv \
	/scratch/group/csce435/Matrix/snap/as20000102/as20000102_adj.tsv \
	/scratch/group/csce435/Matrix/snap/ca-AstroPh/ca-AstroPh_adj.tsv \
	/scratch/group/csce435/Matrix/snap/ca-CondMat/ca-CondMat_adj.tsv \
	/scratch/group/csce435/Matrix/snap/ca-GrQc/ca-GrQc_adj.tsv \
	/scratch/group/csce435/Matrix/snap/ca-HepPh/ca-HepPh_adj.tsv \
	/scratch/group/csce435/Matrix/snap/ca-HepTh/ca-HepTh_adj.tsv \
	/scratch/group/csce435/Matrix/snap/email-Enron/email-Enron_adj.tsv \
	/scratch/group/csce435/Matrix/snap/facebook_combined/facebook_combined_adj.tsv \
	/scratch/group/csce435/Matrix/snap/loc-brightkite_edges/loc-brightkite_edges_adj.tsv \
	/scratch/group/csce435/Matrix/snap/loc-gowalla_edges/loc-gowalla_edges_adj.tsv \
	/scratch/group/csce435/Matrix/snap/oregon2_010526/oregon2_010526_adj.tsv \
	/scratch/group/csce435/Matrix/snap/p2p-Gnutella31/p2p-Gnutella31_adj.tsv \
	/scratch/group/csce435/Matrix/snap/roadNet-CA/roadNet-CA_adj.tsv \
	/scratch/group/csce435/Matrix/snap/roadNet-PA/roadNet-PA_adj.tsv \
	/scratch/group/csce435/Matrix/snap/roadNet-TX/roadNet-TX_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/image-grid/g-1045506-262144_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/image-grid/g-16764930-4194304_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/image-grid/g-260610-65536_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/image-grid/g-4188162-1048576_adj.tsv \
	/scratch/group/csce435/Matrix/ssget/DIMACS10/hugebubbles-00020_adj.tsv \
	/scratch/group/csce435/Matrix/ssget/vanHeukelum/cage15_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/graph500-scale18-ef16/graph500-scale18-ef16_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/graph500-scale19-ef16/graph500-scale19-ef16_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/graph500-scale20-ef16/graph500-scale20-ef16_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/graph500-scale21-ef16/graph500-scale21-ef16_adj.tsv \
	/scratch/group/csce435/Matrix/synthetic/graph500-scale22-ef16/graph500-scale22-ef16_adj.tsv

# redundant:
#	/scratch/group/csce435/Matrix/snap/oregon1_010331/oregon1_010331_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010407/oregon1_010407_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010414/oregon1_010414_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010421/oregon1_010421_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010428/oregon1_010428_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010505/oregon1_010505_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010512/oregon1_010512_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010519/oregon1_010519_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon1_010526/oregon1_010526_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010331/oregon2_010331_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010407/oregon2_010407_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010414/oregon2_010414_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010421/oregon2_010421_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010428/oregon2_010428_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010505/oregon2_010505_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010512/oregon2_010512_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/oregon2_010519/oregon2_010519_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella04/p2p-Gnutella04_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella05/p2p-Gnutella05_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella06/p2p-Gnutella06_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella08/p2p-Gnutella08_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella09/p2p-Gnutella09_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella24/p2p-Gnutella24_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella25/p2p-Gnutella25_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/p2p-Gnutella30/p2p-Gnutella30_adj.tsv \

# take too long:
#	/scratch/group/csce435/Matrix/ssget/Freescale/circuit5M_adj.tsv \
#	/scratch/group/csce435/Matrix/synthetic/graph500-scale23-ef16/graph500-scale23-ef16_adj.tsv

# too big for the GPU:
#	/scratch/group/csce435/Matrix/synthetic/image-grid/g-268386306-67108864_adj.tsv \
#	/scratch/group/csce435/Matrix/synthetic/graph500-scale24-ef16/graph500-scale24-ef16_adj.tsv \
#	/scratch/group/csce435/Matrix/synthetic/graph500-scale25-ef16/graph500-scale25-ef16_adj.tsv \
#	/scratch/group/csce435/Matrix/snap/friendster/friendster_adj.tsv \

