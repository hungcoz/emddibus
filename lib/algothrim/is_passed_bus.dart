  bool isPassed(int point, int nextPoint, List<dynamic> listPoint) {
    int pointIndex = -1;
    int nextPointIndex = listPoint.length + 1;
    for (int i = 0; i < listPoint.length; i++) {
      if (point == listPoint[i]) {
        pointIndex = i;
      }
      if (nextPoint == listPoint[i]) {
        nextPointIndex = i;
      }
    }
    if (pointIndex >= nextPointIndex)
      return true;
    else
      return false;
  }