module "Network" {
  source = "./Network"
  publicSN-availability-zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"] 
  privateSN-availability-zones = ["us-east-1e", "us-east-1f"]
}
module "AS-Group" {
  source = "./AS-Group"
  vpc-id = module.Network.mainvpc
  publicSNs = module.Network.publicSNs
  endpoint = module.Database.endpoint
}
module "Database" {
  source = "./Database"
  privateSNs = module.Network.privateSNs
  vpc-id = module.Network.mainvpc
  app-sg-id = module.AS-Group.app-SG-id
}
