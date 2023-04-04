# k8s cluster upgrade

## the flow chart

## instruction

### backup

#### backup and restore etcd data

https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md#restoring-a-cluster

```bash

etcdctl --cacert --cert --key --endpoints

```

### upgrade control plane


### upgrade node

### upgrade argrithm

1node 2node 4node 8node maxium 10% nodes number