using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using MLAPI;
using MLAPI.Transports.UNET;
using MLAPI.Messaging;
using MLAPI.NetworkVariable;

public class TabletopManager : MonoBehaviour {
    private static TabletopManager _singleton;
    public static TabletopManager Singleton { get { return _singleton; } }
    public Text ipText = null;

    void Start() {
        
    }
    
    void Update() {
        
    }

    private void Awake() {
        if(_singleton != null && _singleton != this) {
            Destroy(this.gameObject);
        } else {
            _singleton = this;
        }
    }

    void OnGUI() {
        GUILayout.BeginArea(new Rect(10, 30, 120, 300));
        if (!NetworkManager.Singleton.IsClient && !NetworkManager.Singleton.IsServer) {
            StartButtons();
        } else {
            StatusLabels();

            //SubmitNewPosition();
        }

        GUILayout.EndArea();
    }

    void StartButtons() {
        if (GUILayout.Button("Host")) NetworkManager.Singleton.StartHost();
        //if (GUILayout.Button("Client")) NetworkManager.Singleton.StartClient();
        if (GUILayout.Button("Client")) Join();
        if (GUILayout.Button("Server")) NetworkManager.Singleton.StartServer();
    }

    static void StatusLabels() {
        var mode = NetworkManager.Singleton.IsHost ?
            "Host" : NetworkManager.Singleton.IsServer ? "Server" : "Client";

        GUILayout.Label("Transport: " +
            NetworkManager.Singleton.NetworkConfig.NetworkTransport.GetType().Name);
        GUILayout.Label("Mode: " + mode);
    }

    static void SubmitNewPosition() {
        if (GUILayout.Button(NetworkManager.Singleton.IsServer ? "Move" : "Request Position Change")) {
            if (NetworkManager.Singleton.ConnectedClients.TryGetValue(NetworkManager.Singleton.LocalClientId,
                out var networkedClient)) {
                var player = networkedClient.PlayerObject.GetComponent<TabletopPlayer>();
                if (player) {
                    player.Move();
                }
            }
        }
    }

    public void Join() {
        NetworkManager.Singleton.GetComponent<UNetTransport>().ConnectAddress = ipText.text;
        NetworkManager.Singleton.StartClient();
        
    }

    [ServerRpc]
    private void SpawnServerRpc(int index, Vector3 pos) {
        Debug.Log("Spawn Requested");
        GameObject obj = NetworkManager.Singleton.NetworkConfig.NetworkPrefabs[index].Prefab;
        Instantiate(obj, pos, Quaternion.identity);
    }

    private void ServerSpawn(int index, Vector3 pos) {
        if (NetworkManager.Singleton.IsHost) {
            GameObject obj = NetworkManager.Singleton.NetworkConfig.NetworkPrefabs[index].Prefab;
            Instantiate(obj, pos, Quaternion.identity);
        }
    }

    public void Spawn(int index, Vector3 pos) {
        if (NetworkManager.Singleton.IsHost) {
            ServerSpawn(index, pos);
        } else if (NetworkManager.Singleton.IsClient) {
            SpawnServerRpc(index, pos);
        }
    }
}
