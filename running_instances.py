from multiprocessing.connection import wait
import boto3
from pprint import pprint
aws_con = boto3.session.Session(profile_name='root')

ec2 = aws_con.client(service_name='ec2',region_name='us-east-1')
ec2_res = aws_con.resource(service_name='ec2',region_name='us-east-1')

all_instances_id=[]
for i in ec2_res.instances.all():
    all_instances_id.append(i.id)
    print("Instance id:{}".format(i.id))
    print("Instance state:{}".format(i.state['Name']))
    print("Instance launch time:{}".format(i.launch_time.strftime("%Y-%m-%d %H:%M:%S")))
    print("Instance public ip:{}".format(i.public_ip_address))
    print("Instance private ip:{}".format(i.private_ip_address))
    print("Instance public dns:{}".format(i.public_dns_name))
    print("Instance private dns:{}".format(i.private_dns_name))
    print("Instance type:{}".format(i.instance_type))
    print("Instance ami:{}".format(i.image_id))
    print("Instance key name:{}".format(i.key_name))
    print("Instance subnet id:{}".format(i.subnet_id))
    print("Instance security group id:{}".format(i.security_groups))
    print("Instance placement:{}".format(i.placement['AvailabilityZone']))
    print("Instance tenancy:{}".format(i.placement['Tenancy']))
    print("Instance placement group:{}".format(i.placement['GroupName']))
    print("Instance monitoring:{}".format(i.monitoring['State']))
    print("Instance tags:{}".format(i.tags))
    print("Instance volumes:{}".format(i.volumes))
    print("Instance vpc id:{}".format(i.vpc_id))
    print("Instance private ip address:{}".format(i.private_ip_address))
    print("Instance public ip address:{}".format(i.public_ip_address))
    print("Instance public dns name:{}".format(i.public_dns_name))
    print("Instance private dns name:{}".format(i.private_dns_name))
    # print("Instance launch time:{}".format(i.launch_time.
    
# waiter.wait(InstanceIds=all_instances_id)    
print("All instances are running")

