using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using MLAPI;

public class MouseControls : MonoBehaviour {
    public enum ClickMode { None, Grab, GeneratePawn, SculptTerrain  };
    public ClickMode clickMode;
    public GameObject HexCellPrefab;
    public GameObject PawnPrefab;
    public GameObject NetPawnPrefab;
    public TabletopManager ttm;
    private Vector3 HoverPoint;
    private Vector3 ThrowForce = new Vector3();
    private GameObject carriedObject = null;
    private Die targetDie = null;
    private GameObject projector;
    private float brushSize = 1f;
    private bool alt = false;
    public Canvas canvas = null;
    private List<KeyValuePair<Rect, string>> labels = new List<KeyValuePair<Rect, string>>();
    private bool oldKin = false;

    void Start() {
        clickMode = ClickMode.Grab;
        HoverPoint = new Vector3();
        projector = GameObject.Find("Sculpting_Projector");
    }

    // Update is called once per frame
    void Update() {
        labels.Clear();
        if (Input.GetButtonDown("Command1")) {
            clickMode = ClickMode.Grab;
            if (projector != null) {
                projector.SetActive(true);
            }

        }
        if (Input.GetButtonDown("Command2")) {
            clickMode = ClickMode.GeneratePawn;
            if (projector != null) {
                projector.SetActive(false);
            }
        }
        if (Input.GetButtonDown("Command3")) {
            clickMode = ClickMode.SculptTerrain;
            if (projector != null) {
                projector.SetActive(false);
            }
        }

        if (Input.GetAxis("SizeChange") != 0) {
            if (clickMode == ClickMode.SculptTerrain) {
                SetBrushSize(brushSize + Input.GetAxis("SizeChange") * Time.deltaTime * 3f);
            }
        }
        if(!IsPointerOverUIElement()) {
            RaycastHit hitInfo = new RaycastHit();
            Ray mouseRay = Camera.main.ScreenPointToRay(Input.mousePosition);
            bool hit = Physics.Raycast(mouseRay, out hitInfo);
            if (hit) {
                HoverPoint.x = hitInfo.point.x;
                HoverPoint.z = hitInfo.point.z;
                HoverPoint.y = hitInfo.point.y + 1;
            } else {
                Plane bottomPlane = new Plane(Vector3.up, Vector3.zero);
                if (bottomPlane.Raycast(mouseRay, out float distance)) {
                    HoverPoint = mouseRay.GetPoint(distance);
                }
            }

            switch (clickMode) {
                case ClickMode.Grab: { // ==========================================================================================================================
                    if (Input.GetMouseButtonDown(0)) {
                        if (hit) {
                            if (hitInfo.collider.gameObject.GetComponent<GamePiece>() != null) {
                                targetDie = hitInfo.collider.gameObject.GetComponent<Die>();
                                hitInfo.collider.gameObject.transform.rotation =
                                    Quaternion.Euler(hitInfo.collider.gameObject.transform.eulerAngles.x, 0, hitInfo.collider.gameObject.transform.eulerAngles.z);
                                carriedObject = hitInfo.collider.gameObject;
                                oldKin = carriedObject.GetComponent<Rigidbody>().isKinematic;
                                carriedObject.GetComponent<Rigidbody>().isKinematic = true;
                                if (carriedObject.GetComponentInChildren<Die>() == null) {
                                    carriedObject.transform.rotation = new Quaternion();
                                }
                                carriedObject.layer = 2;
                                ThrowForce = Vector3.zero;

                                GodPawnScript gps = hitInfo.collider.gameObject.GetComponent<GodPawnScript>();
                                if (gps != null) {
                                    Text messageText = GameObject.Find("MessageText").GetComponent<Text>();
                                    messageText.text = gps.GetRandomMessage();
                                }
                            }
                        }
                    }

                    if (Input.GetMouseButton(1)) {

                    }

                    if (Input.GetMouseButtonDown(1) && carriedObject != null) {
                        carriedObject.transform.Rotate(new Vector3(0, 10, 0));
                    }

                    if (Input.GetMouseButtonUp(0)) {
                        if (carriedObject != null) {
                            carriedObject.GetComponent<Rigidbody>().isKinematic = oldKin;
                            carriedObject.layer = 0;
                            carriedObject.GetComponent<Rigidbody>().AddForce(ThrowForce * 200f);
                            if (carriedObject.GetComponentInChildren<Die>() != null) {
                                carriedObject.GetComponent<Rigidbody>().AddTorque(ThrowForce * 20f);
                            }
                            carriedObject = null;
                        }
                    }
                    break;
                }
                case ClickMode.GeneratePawn: { // ==================================================================================================================
                    if (Input.GetMouseButtonDown(0)) {
                        if (NetworkManager.Singleton.IsServer) {
                            Debug.Log("Narm!");
                            TabletopManager.Singleton.Spawn(0, HoverPoint);
                        } else if(NetworkManager.Singleton.IsClient) {
                            Debug.Log("Farm!");
                            TabletopManager.Singleton.Spawn(0, HoverPoint);
                        } else {
                            GameObject newPawn = GameObject.Instantiate(PawnPrefab, HoverPoint, new Quaternion());
                        }
                    }
                    break;
                }
                case ClickMode.SculptTerrain: { // ==================================================================================================================
                    if (canvas != null) {
                        if (hit) {
                            HexMesh hex = hitInfo.transform.gameObject.GetComponentInParent<HexMesh>();
                            if (hex != null) {

                                Vector3 localHit = hex.transform.InverseTransformPoint(hitInfo.point);
                                Vector2Int target = hex.PointToHexCoordinate(localHit);

                                Hex[] cells = hex.map.CellAt(target).Neighbors((int)brushSize);
                                foreach (Hex h in cells) {
                                    Vector3 loc = hex.HexWorldCoordinate(h);
                                    Vector2 scr = Camera.main.WorldToScreenPoint(loc);
                                    scr.y = Screen.height - scr.y;
                                    labels.Add(new KeyValuePair<Rect, string>(new Rect((int)(scr.x - 10f), (int)(scr.y - 10f), 20, 20), hex.map.CellAt(target).DistanceTo(h).ToString()));
                                }
                            }
                        }
                    }


                    if (Input.GetMouseButtonDown(0)) {

                    }

                    if (Input.GetMouseButton(0)) {
                        if (hit) {
                            HexMesh hex = hitInfo.transform.gameObject.GetComponentInParent<HexMesh>();
                            if (hex != null) {

                                Vector3 localHit = hex.transform.InverseTransformPoint(hitInfo.point);
                                Vector2Int target = hex.PointToHexCoordinate(localHit);
                                if (Input.GetKey(KeyCode.LeftControl)) {
                                    hex.AdjustHeight(target.x, target.y, (int)brushSize, -2f * Time.deltaTime);
                                } else {
                                    hex.AdjustHeight(target.x, target.y, (int)brushSize, 2f * Time.deltaTime);
                                }

                                hex.UpdateMesh();
                                if (alt) {
                                    hex.UpdateColliderMesh();
                                }
                            }
                        }
                    }

                    if (projector != null) {
                        projector.transform.position = HoverPoint + Vector3.up * 50;
                    }
                    break;
                }
            } // ===================================================================================================================================================
        }
        

        if (carriedObject != null) {
            if(clickMode == ClickMode.Grab) {
                Vector3 oldPos = carriedObject.transform.position;
                Vector3 heightAdjust = Vector3.up;
                Collider c = carriedObject.GetComponent<Collider>();
                if(c != null) {
                    heightAdjust *= c.bounds.extents.magnitude / 2f;
                }
                
                carriedObject.transform.Translate((HoverPoint + heightAdjust) - oldPos, Space.World);

                TabletopPlayer tp = carriedObject.GetComponent<TabletopPlayer>();
                if(tp != null) {
                    tp.Move(carriedObject.transform.position);
                }

                ThrowForce += carriedObject.transform.position - oldPos;
                ThrowForce *= 0.9f;
                if (ThrowForce.magnitude < 0.01f) ThrowForce = Vector3.zero;

                if (carriedObject.GetComponentInChildren<Die>() != null) {
                    carriedObject.transform.Rotate(ThrowForce * 20f, Space.World);
                }
            } else {
                carriedObject.GetComponent<Rigidbody>().isKinematic = false;
                carriedObject.layer = 0;
                carriedObject.GetComponent<Rigidbody>().AddForce(ThrowForce * 200f);
                carriedObject = null;
            }
        }

        Text t = GameObject.Find("DebugText").GetComponent<Text>();
        //t.text = ThrowForce.ToString();
        if (targetDie != null) t.text = targetDie.gameObject.transform.rotation.normalized + " " + targetDie.GetCurrentFaceValue();

        alt = !alt;
    }

    private void OnGUI() {
        if(labels.Count > 0) {
            foreach(KeyValuePair<Rect, string> val in labels) {
                GUI.Label(val.Key, val.Value);
            }
        }
    }

    public static bool IsPointerOverUIElement() {
        return IsPointerOverUIElement(GetEventSystemRaycastResults());
    }

    public static bool IsPointerOverUIElement(List<RaycastResult> eventSystemRaycastResults) {
        for(int i = 0; i < eventSystemRaycastResults.Count; ++i) {
            RaycastResult cur = eventSystemRaycastResults[i];
            if (cur.gameObject.layer == LayerMask.NameToLayer("UI")) return true;
        }
        return false;
    }

    static List<RaycastResult> GetEventSystemRaycastResults() {
        PointerEventData eventData = new PointerEventData(EventSystem.current);
        eventData.position = Input.mousePosition;
        List<RaycastResult> raycastResults = new List<RaycastResult>();
        EventSystem.current.RaycastAll(eventData, raycastResults);
        return raycastResults;
    }

    public void AdjustBrushSize(float amount) {
        SetBrushSize(brushSize + amount);
    }

    public void SetBrushSize(float newSize) {
        brushSize = Mathf.Clamp(newSize, 1, 20);
        Text brushText = GameObject.Find("BrushSizeText").GetComponent<Text>();
        if (brushText != null) {
            brushText.text = brushSize.ToString();
        }
    }

    public void SetClickMode(int mode) {
        SetClickMode((ClickMode)mode);
    }

    public void SetClickMode(ClickMode mode) {
        clickMode = mode;
    }
}
