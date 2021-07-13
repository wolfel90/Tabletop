using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MLAPI;
using MLAPI.Messaging;
using MLAPI.NetworkVariable;

public class TabletopPlayer : NetworkBehaviour {
    public NetworkVariableVector3 Position = new NetworkVariableVector3(new NetworkVariableSettings {
        WritePermission = NetworkVariablePermission.ServerOnly,
        ReadPermission = NetworkVariablePermission.Everyone
    });
    public NetworkVariableQuaternion Rotation = new NetworkVariableQuaternion(new NetworkVariableSettings {
        WritePermission = NetworkVariablePermission.ServerOnly,
        ReadPermission = NetworkVariablePermission.Everyone
    });

    void Start() {
        
    }
    
    void Update() {
        transform.position = Position.Value;
        transform.rotation = Rotation.Value;
    }
    
    public override void NetworkStart() {
        Move();
    }

    public void Move() {
        if (NetworkManager.Singleton.IsServer) {
            var randomPosition = GetRandomPositionOnPlane();
            transform.position = randomPosition;
            Position.Value = randomPosition;
        } else {
            SubmitPositionRequestServerRpc();
        }
    }

    public void Move(Vector3 pos) {
        if (NetworkManager.Singleton.IsServer) {
            transform.position = pos;
            Position.Value = pos;
        } else {
            SubmitPositionRequestServerRpc(pos);
        }
    }

    [ServerRpc]
    void SubmitPositionRequestServerRpc(ServerRpcParams rpcParams = default) {
        Position.Value = GetRandomPositionOnPlane();
    }

    [ServerRpc]
    void SubmitPositionRequestServerRpc(Vector3 pos, ServerRpcParams rpcParams = default) {
        Position.Value = pos;
    }

    static Vector3 GetRandomPositionOnPlane() {
        return new Vector3(Random.Range(0, 5f), 1f, Random.Range(0, 5f));
    }
}
