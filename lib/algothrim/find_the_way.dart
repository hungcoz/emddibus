// import 'package:emddibus/constants.dart';
// import 'package:emddibus/models/stop_point_model.dart';
//
// void findTheWay(StopPoint start, StopPoint target) {
//   List<StopPoint> open = [start];
//   List<StopPoint> close = [];
//   while (open.isNotEmpty) {
//     var value = open[0];
//     open.removeAt(0);
//     if (close.contains(value)) continue;
//     if (value.stopId == target.stopId) {
//       close.add(value);
//       close.forEach((element) {
//         print(element.stopId);
//       });
//       return;
//     } else {
//       close.add(value);
//       BUS_ROUTE.forEach((element) {
//         if (element.listStopPointReturn.contains(value.stopId)) {
//           for (int i = 0; i < element.listStopPointReturn.length; i++) {
//             if (element.listStopPointReturn[i] == value.stopId) {
//               STOP_POINT.forEach((point) {
//                 if (i + 1 >= element.listStopPointReturn.length)
//                   return;
//                 else if (point.stopId == element.listStopPointReturn[i + 1] &&
//                     !open.contains(point)) {
//                   open.add(point);
//                 }
//               });
//             }
//           }
//         }
//         if (element.listStopPointGo.contains(value.stopId)) {
//           for (int i = 0; i < element.listStopPointGo.length; i++) {
//             if (element.listStopPointGo[i] == value.stopId) {
//               STOP_POINT.forEach((point) {
//                 if (i + 1 >= element.listStopPointGo.length)
//                   return;
//                 else if (point.stopId == element.listStopPointGo[i + 1] &&
//                     !open.contains(point)) {
//                   open.add(point);
//                 }
//               });
//             }
//           }
//         }
//       });
//     }
//   }
// }
import 'dart:collection';

import 'package:emddibus/algothrim/calculate_distance.dart';
import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class Node extends Object {
  StopPoint currentNode;
  Node parent;
  int routeId;
  int chosenId;
  int count = 0;
  int direction;
  double distance = 0.5;
  int crossStreet = 0;
  bool isInOpenSet = false; // Much faster than finding nodes in iterables.
  bool isInClosedSet = false;
}

/*
đổi chiều trg cùng 1 tuyến => count+1
đổi tuyến xe => count+1
count >= 3 ngừng xét
 */

class AStar {
  final List<Queue<Node>> NO_VALID_PATH = [];

  bool check;
  Node tmpCandidate;

  Future<List<Queue<Node>>> findPath(StopPoint start, StopPoint goal) {
    return new Future<List<Queue<Node>>>(() => findPathSync(start, goal));
  }

  List<Queue<Node>> findPathSync(StopPoint startPoint, StopPoint goalPoint) {
    /*
    kiểm tra điểm bắt đầu với kết thúc có trùng nhau hay không
     */
    if (startPoint.stopId == goalPoint.stopId) {
      return NO_VALID_PATH;
    } else {
      Node goal = new Node();
      goal.currentNode = goalPoint;

      List<Queue<Node>> allList = []; // danh sách các tuyến đường phù hợp
      final Queue<Node> open = new Queue<Node>(); // danh sách các điểm đi qua

      Node lastClosed; // lưu node cha

      /* lấy danh sách các tuyến đi qua điểm bắt đầu
      */
      BUS_ROUTE.forEach((element) {
        if (element.listStopPointGo.contains(startPoint.stopId) &&
            element.listStopPointGo[element.listStopPointGo.length - 1] !=
                startPoint.stopId) {
          Node start = new Node();
          start.routeId = element.routeId;
          start.currentNode = startPoint;
          start.isInOpenSet = true;
          open.addLast(start);
        }
        if (element.listStopPointReturn.contains(startPoint.stopId) &&
            element.listStopPointReturn[
                    element.listStopPointReturn.length - 1] !=
                startPoint.stopId) {
          Node start = new Node();
          start.routeId = element.routeId;
          start.currentNode = startPoint;
          start.isInOpenSet = true;
          open.addLast(start);
        }
      });

      while (open.isNotEmpty) {
        Node currentNode = new Node();
        currentNode = open.elementAt(0);
        /* Ktra điểm dừng hiện tại có phải là đích đến hay k
        => nếu đúng thì từ điểm đó lấy ngược lại các node cha để tạo thành
        1 tuyến đường phù hợp
         */
        if (currentNode.currentNode.stopId == goal.currentNode.stopId) {
          // queues are more performant when adding to the front
          Node tmp = new Node();
          tmp = currentNode;
          final Queue<Node> path = new Queue<Node>();
          path.add(tmp);

          while (tmp.parent != null) {
            tmp = tmp.parent;
            path.addFirst(tmp);
          }

          allList.add(path);

          open.remove(currentNode);
          /* sau khi tìm đc 1 tuyến đường => ktra nếu open rỗng thì trả về danh sách các
          tuyến đường, nếu open k rỗng => xét tiếp điểm tiếp theo,
          khởi tạo lại vòng lặp while
           */
          if (open.isNotEmpty) {
            // currentNode = open.elementAt(0);
            continue;
          } else {
            return allList;
          }
        }

        open.remove(currentNode);
        currentNode.isInOpenSet = false; // Much faster than finding nodes in iterables.
        lastClosed = currentNode;
        currentNode.isInClosedSet = true;

        List<Node> listNeighbours = getNeighboursOf(currentNode);
        List<Node> listOpposites= getOppositeOf(currentNode);

        /*
        sau khi lấy đc các node con của node hiện tại thì thực hiện ktra
        => thêm vào open
         */
        for (final candidate in listNeighbours) {
          if (candidate.isInOpenSet == false) {
            candidate.parent = lastClosed;
            tmpCandidate = new Node();
            check = false;
            checkIsInOpen(open, candidate);
            if (check) {
              open.remove(tmpCandidate);
              continue;
            }
            if (candidate.count <= 2) {
              open.add(candidate);
            }
            candidate.isInOpenSet = true;
          }
        }
        for (final opposite in listOpposites) {
          if (opposite.isInOpenSet == false) {
            opposite.parent = lastClosed;
            tmpCandidate = new Node();
            check = false;
            checkIsInOpen(open, opposite);
            if (check) {
              open.remove(tmpCandidate);
              continue;
            }
            if (opposite.count <= 2) {
              open.add(opposite);
            }
            opposite.isInOpenSet = true;
          }
        }
      }
      if (allList.isNotEmpty)
        return allList;
      else
        // k tìm thấy tuyến đường phù hợp
        return NO_VALID_PATH;
    }
  }

  /*
  ktra để lọc các điểm trùng, ưu tiên lấy các điểm có cùng routeId với node cha
   */
  void checkIsInOpen(Queue<Node> open, Node candidate) {
    for (final element in open) {
      if (candidate.routeId == element.routeId &&
          candidate.currentNode.stopId == element.currentNode.stopId) {
        if (candidate.crossStreet == element.crossStreet) {
          if (candidate.routeId == candidate.parent.routeId &&
              element.routeId != element.parent.routeId &&
              candidate.count <= 2) {
            tmpCandidate = element;
            open.add(candidate);
            check = true;
            break;
          } else if (candidate.routeId != candidate.parent.routeId &&
              element.routeId == element.parent.routeId) {
            check = true;
            break;
          }
        }
        else {
          if (candidate.crossStreet == 1 && element.crossStreet == 0) {
            tmpCandidate = element;
            open.add(candidate);
            check = true;
            break;
          } else if (candidate.crossStreet == 0 && element.crossStreet == 1) {
            check = true;
            break;
          }
        }
      }
    }
  }

  /*
  lấy danh sách các node con của điểm hiện tại đang xét
   */
  List<Node> getNeighboursOf(Node currentNode) {
    List<Node> listNeighbours = [];
    BUS_ROUTE.forEach((element) {
      if (element.listStopPointGo.contains(currentNode.currentNode.stopId)) {
        // ktra đổi chiều
        // if (currentNode.direction == 1 &&
        //     element.listStopPointReturn
        //         .contains(currentNode.currentNode.stopId)) {
        //   currentNode.count += 1;
        // }
        /*
        tìm các tuyến xe đi qua điểm hiện tại rồi lấy điểm ngay sau đó
        mà mỗi tuyến đi qua
         */
        for (int i = 0; i < element.listStopPointGo.length; i++) {
          if (element.listStopPointGo[i] == currentNode.currentNode.stopId) {
            for (final point in STOP_POINT) {
              if (i + 1 >= element.listStopPointGo.length)
                break;
              else if (point.stopId == element.listStopPointGo[i + 1]) {
                Node child = new Node();
                child.currentNode = point;
                child.routeId = element.routeId;
                child.count = currentNode.count;
                if (currentNode.direction == 1 &&
                    element.listStopPointReturn
                        .contains(currentNode.currentNode.stopId)) {
                  child.count += 1;
                }
                child.direction = 0;
                // ktra đổi tuyến
                if (child.routeId != currentNode.routeId) child.count++;
                listNeighbours.add(child);
                break;
              }
            }
            break;
          }
        }
      }
      if (element.listStopPointReturn
          .contains(currentNode.currentNode.stopId)) {
        // ktra đổi chiều
        // if (currentNode.direction == 0 &&
        //     element.listStopPointGo.contains(currentNode.currentNode.stopId)) {
        //   currentNode.count += 1;
        // }
        /*
        tìm các tuyến xe đi qua điểm hiện tại rồi lấy điểm ngay sau đó
        mà mỗi tuyến đi qua
         */
        for (int i = 0; i < element.listStopPointReturn.length; i++) {
          if (element.listStopPointReturn[i] ==
              currentNode.currentNode.stopId) {
            for (final point in STOP_POINT) {
              if (i + 1 >= element.listStopPointReturn.length)
                break;
              else if (point.stopId == element.listStopPointReturn[i + 1]) {
                Node child = Node();
                child.currentNode = point;
                child.routeId = element.routeId;
                child.count = currentNode.count;
                if (currentNode.direction == 0 &&
                    element.listStopPointGo.contains(currentNode.currentNode.stopId)) {
                  child.count += 1;
                }
                child.direction = 1;
                // ktra đổi tuyến
                if (child.routeId != currentNode.routeId) child.count++;
                listNeighbours.add(child);
                break;
              }
            }
            break;
          }
        }
      }
    });
    return listNeighbours;
  }
  List<Node> getOppositeOf(Node currentNode){
    List<Node> listOpposite = [];
    List<Node> listNeighbour = getNeighboursOf(currentNode);
    Node oppositeOf = new Node();
    STOP_POINT.forEach((element) {
      LatLng current = LatLng(currentNode.currentNode.latitude, currentNode.currentNode.longitude);
      LatLng opposite = LatLng(element.latitude, element.longitude);
      if (calculateDistance(current, opposite) <= 0.5 && calculateDistance(current, opposite) > 0 && calculateDistance(current, opposite) < oppositeOf.distance) {
        oppositeOf.currentNode = element;
        oppositeOf.distance = calculateDistance(current, opposite);
      }
    });
    if (oppositeOf.currentNode != null) {
      BUS_ROUTE.forEach((element) {
        if (element.listStopPointGo.contains(oppositeOf.currentNode.stopId) &&
            element.listStopPointReturn.contains(oppositeOf.currentNode.stopId)) {
          Node node = new Node();
          node.currentNode = oppositeOf.currentNode;
          node.routeId = element.routeId;
          node.direction = 0;
          node.count = currentNode.count+1;
          node.crossStreet = 1;
          node.distance = oppositeOf.distance;
          int count = 0;
          listNeighbour.forEach((element) {
            if (element.currentNode.stopId == node.currentNode.stopId)
              count++;
          });
          if (count == 0) {
            if (currentNode.parent != null) {
              if (currentNode.parent.currentNode.stopId != node.currentNode.stopId)
                listOpposite.add(node);
            }
            else if (currentNode.parent == null) listOpposite.add(node);
          }
        }
        else if (element.listStopPointGo.contains(oppositeOf.currentNode.stopId)) {
          Node node = new Node();
          node.currentNode = oppositeOf.currentNode;
          node.routeId = element.routeId;
          node.direction = 0;
          node.count = currentNode.count+1;
          node.crossStreet = 1;
          node.distance = oppositeOf.distance;
          int count = 0;
          listNeighbour.forEach((element) {
            if (element.currentNode.stopId == node.currentNode.stopId)
              count++;
          });
          if (count == 0) {
            if (currentNode.parent != null) {
              if (currentNode.parent.currentNode.stopId != node.currentNode.stopId)
                listOpposite.add(node);
            }
            else if (currentNode.parent == null) listOpposite.add(node);
          }
        }
        else if (element.listStopPointReturn.contains(oppositeOf.currentNode.stopId)) {
          Node node = new Node();
          node.currentNode = oppositeOf.currentNode;
          node.routeId = element.routeId;
          node.direction = 1;
          node.count = currentNode.count+1;
          node.crossStreet = 1;
          node.distance = oppositeOf.distance;
          int count = 0;
          listNeighbour.forEach((element) {
            if (element.currentNode.stopId == node.currentNode.stopId)
              count++;
          });
          if (count == 0) {
            if (currentNode.parent != null) {
              if (currentNode.parent.currentNode.stopId != node.currentNode.stopId)
                listOpposite.add(node);
            }
            else if (currentNode.parent == null) listOpposite.add(node);
          }
        }
      });
    }
    return listOpposite;
  }
}
