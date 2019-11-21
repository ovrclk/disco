# Layer 3

## Akash Nodes

In this layer we'll install Akash nodes

### Generate Genesis

#### 1.Create Master and Node Keys

```
akash key create master
```

#### 2. Add Nodes to DB index

Add nodes to DB index:

```
cat > data/db/index/NODES <<EOF
node1
node2
node3
EOF
```

#### 3. Create Helm configuration with genesis file

```
make akashd-init
```

#### 4. Install Akash Nodes

```
make akash-node-install L3_DOMAIN=node.sjc1.ovrclk1.com HOST=node.sjc1.ovrclk1.com NODE=node1
make akash-node-install L3_DOMAIN=node.sjc1.ovrclk1.com HOST=node.sjc1.ovrclk1.com NODE=node2
make akash-node-install L3_DOMAIN=node.sjc1.ovrclk1.com HOST=node.sjc1.ovrclk1.com NODE=node3
```

#### 5. Verify Nodes

### Akash Provider

```

```
