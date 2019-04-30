#!/usr/bin/env bash

set -e

NODE_ID=$(docker info -f "{{.Swarm.NodeID}}")
NODE_NAME=$(cat /etc/hostname)
echo "node_meta{node_id=\"$NODE_ID\", container_label_com_docker_swarm_node_id=\"$NODE_ID\", node_name=\"$NODE_NAME\"} 1" | tee /etc/node-meta.prom
ls -la /etc/node-meta.prom
