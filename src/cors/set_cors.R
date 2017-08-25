# sets cors to the appropriate covariance matrix
set_cors_baselines <- function(pre,suff,ll=FALSE){
  if(suff=="group" || suff=="fused"){
    return(cors_nsimule)
  }
  if(ll){
    if(pre=="n"){
      if(suff==""){
        cors = cors_ll_nsimule
      } else if(suff=="_i"){
        cors = cors_ll_nsimule_i
      } else if(suff=="_p"){
        cors = cors_ll_simule_p
      }
    } else if(pre==""){
      if(suff==""){
        cors = cors_ll_simule
      } else if(suff=="_i"){
        cors = cors_ll_simule_i
      } else if(suff=="_p"){
        cors = cors_ll_simule_p
      }
    }
  }
  if(pre=="n"){
    if(suff==""){
      cors = cors_nsimule
    } else if(suff=="_i"){
      cors = cors_nsimule_i
    } else if(suff=="_p"){
      cors = cors_simule_p
    }
  } else if(pre==""){
    if(suff==""){
      cors = cors_simule
    } else if(suff=="_i"){
      cors = cors_simule_i
    } else if(suff=="_p"){
      cors = cors_simule_p
    }
  }
  return(cors)
}