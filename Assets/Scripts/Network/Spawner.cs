using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MLAPI;
using MLAPI.Transports.UNET;
using MLAPI.Messaging;
using MLAPI.NetworkVariable;

public class Spawner : NetworkBehaviour {
    [ServerRpc]
    private void SpawnServerRpc(int index, Vector3 pos) {
        if(NetworkManager.Singleton.IsHost) {
            GameObject obj = NetworkManager.Singleton.NetworkConfig.NetworkPrefabs[index].Prefab;
            Instantiate(obj, pos, Quaternion.identity);
        }
    }

    private void ServerSpawn(int index, Vector3 pos) {
        if(NetworkManager.Singleton.IsHost) {
            GameObject obj = NetworkManager.Singleton.NetworkConfig.NetworkPrefabs[index].Prefab;
            Instantiate(obj, pos, Quaternion.identity);
        }
    }

    public void Spawn(int index, Vector3 pos) {
        if(NetworkManager.Singleton.IsHost) {
            ServerSpawn(index, pos);
        } else if (NetworkManager.Singleton.IsClient) {
            SpawnServerRpc(index, pos);
        }
    }
}
