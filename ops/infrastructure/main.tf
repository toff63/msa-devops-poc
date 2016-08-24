
module "network" {
    source = "./network"
}


module "public" {
    source = "./public"
    vpc_id = "${module.network.main_vpc_id}"
}

module "services" {
    source = "./services"
    vpc_id = "${module.network.main_vpc_id}"
    nat_gw_id = "${module.network.nat_gw_id}"
    sg_bastion_id = "${module.public.sg_bastion_id}"
}
