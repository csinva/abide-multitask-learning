# 1-4: nglasso, nsimule, nsimule_dist, nclime
# 5-8: nglasso_i, nsimule_i, nsimule_dist_i, nclime_i
# 9-12: glasso, simule, simule_dist, clime
# 13-16: glasso_i, simule_i, simule_dist_i, clime_i
# 17-18: simone, simone_i
# 19-20: jgl_group, jgl_fused
# 21: self_edges
# 22: dpm
# 23-26: nsimule_dist_2, nsimule_dist_3, nsimule_dist_4, nsimule_dist_6
# 27-31: nsimule_dist_labels_1, nsimule_dist_labels_2, nsimule_dist_labels_3, nsimule_dist_networks_1, nsimule_dist_networks_2 
# 32-37: nsimule_dist_labels_1_dist, nsimule_dist_labels_2_dist, nsimule_dist_labels_3_dist, nsimule_dist_labels_1_dist_2, nsimule_dist_labels_2_dist_2, nsimule_dist_labels_3_dist_2
# 38-41: simule_dist_2, simule_dist_3, simule_dist_4, simule_dist_6
# 42-46: simule_dist_labels_1, simule_dist_labels_2, simule_dist_labels_3, simule_dist_networks_1, simule_dist_networks_2 
# 47-52: simule_dist_labels_1_dist, simule_dist_labels_2_dist, simule_dist_labels_3_dist, simule_dist_labels_1_dist_2, simule_dist_labels_2_dist_2, simule_dist_labels_3_dist_2

for i in {48..52}
do
    echo $i
    sbatch --array=$i script_main.sh
    sleep 12s
done