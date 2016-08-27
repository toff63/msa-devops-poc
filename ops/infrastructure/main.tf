
module "network" {
    source = "./network"
}


module "public" {
    source = "./public"
    vpc_id = "${module.network.main_vpc_id}"
    internet_gw_id =  "${module.network.internet_gw_id}"
}

module "services" {
    source = "./services"
    vpc_id = "${module.network.main_vpc_id}"
    nat_gw_id = "${module.public.nat_gw_id}"
    sg_bastion_id = "${module.public.sg_bastion_id}"
}

output "main_vpc_id"         { value="${module.network.main_vpc_id}"}
output "packer_vpc_id"  { value="${module.network.packer_vpc_id}"}
output "packer_sg_id"   {value="${module.network.packer_sg_id}"}
output "packer_subnet_id"   {value="${module.network.packer_subnet_id}"}
output "sg_bastion_id" {value="${module.public.sg_bastion_id}"}
output "public_subnet_id_d" {value="${module.public.public_subnet_id_d}"}
output "public_subnet_id_c" {value="${module.public.public_subnet_id_c}"}
output "public_subnet_id_b" {value="${module.public.public_subnet_id_b}"}
