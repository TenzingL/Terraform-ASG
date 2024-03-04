module "Network" {
  source = "./Network"
  publicSN-availability-zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"] 
  privateSN-availability-zones = ["us-east-1e", "us-east-1f"]
}
module "AS-Group" {
  source = "./AS-Group"
  vpc-id = module.Network.mainvpc
  publicSNs = module.Network.publicSNs
}
