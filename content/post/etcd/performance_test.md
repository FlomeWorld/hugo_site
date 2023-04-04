# Performance
instruction

https://etcd.io/docs/v3.4.0/benchmarks/etcd-3-demo-benchmarks/

## issues

### error info
etcdserver: mvcc: database space exceeded
### solution

https://github.com/etcd-io/etcd/issues/11947
https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/maintenance.md#space-quota
https://github.com/etcd-io/etcd/issues/10312


## performance test
### etcd-proxy

with the high pressure test the proxy not take much resource usage, the request can be set like 0.2c,50m limit can be set like 0.3,100m

