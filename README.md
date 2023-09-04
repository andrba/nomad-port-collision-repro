# Port collision issue in Nomad

When a system job with a static port mapping is updated, its previous allocation may still be holding the port by the time the new allocation is started. This can cause a port collision error which is usually resolved by Nomad in a few seconds.

However, if such system job update is followed by an update of a service job that changes its list of `datacenters`, the service job evaluation reports a port collision error and its deployment gets stuck indefinitely.

The `serv.hcl` service job included in this repo does not have any port mappings. Despite of that, its evaluation output contains port collistion errors:

```
==> 2023-09-04T15:58:09+10:00: Evaluation "47c7b510" finished with status "complete" but failed to place all allocations:
    2023-09-04T15:58:09+10:00: Task Group "group" (failed to place 1 allocation):
      * Resources exhausted on 1 nodes
      * Dimension "network: port collision" exhausted on 1 nodes
    2023-09-04T15:58:09+10:00: Evaluation "c7ace162" waiting for additional capacity to place remainder
```

## Steps to reproduce

1. Start Nomad server and client agents in dev mode:

```
nomad agent -dev
```

2. Run the included script to reproduce the issue. The script creates a system job and a service job, updates both of them in quick succession and finally gets stuck waiting for the service job to be deployed.
```
./script.sh
```

## Nomad versions affected:

- 1.4.12
- 1.5.7
- 1.6.1
