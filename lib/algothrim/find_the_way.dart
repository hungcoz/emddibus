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

import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';

class Node extends Object {
  StopPoint currentNode;
  Node parent;
  int routeId;
  int chosenId;
  int count = 0;
  int direction;
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
      print("Điểm đến là vị trí bắt đầu");
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

        List<Node> listNeighbours = getNeighboursOf(currentNode, lastClosed);

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
    }
  }

  /*
  lấy danh sách các node con của điểm hiện tại đang xét
   */
  List<Node> getNeighboursOf(Node currentNode, Node lastClosed) {
    List<Node> listNeighbours = [];
    BUS_ROUTE.forEach((element) {
      if (element.listStopPointGo.contains(currentNode.currentNode.stopId)) {
        // ktra đổi chiều
        if (currentNode.direction == 1 &&
            element.listStopPointReturn
                .contains(currentNode.currentNode.stopId)) {
          currentNode.count += 1;
        }
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
        if (currentNode.direction == 0 &&
            element.listStopPointGo.contains(currentNode.currentNode.stopId)) {
          currentNode.count += 1;
        }
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
}
