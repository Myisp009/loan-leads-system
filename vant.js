import {
  Button,
  Cell,
  CellGroup,
  Field,
  NavBar,
  Tabbar,
  TabbarItem,
  Card,
  Tag,
  List,
  PullRefresh,
  Toast,
  Dialog,
  Popup,
  Empty,
  Grid,
  GridItem,
  Icon,
  Divider,
  ActionSheet,
  Search,
  Tabs,
  Tab,
  Badge,
  Notify,
  SwipeCell,
  SubmitBar,
  Stepper,
  Loading,
  Skeleton
} from 'vant'

import 'vant/lib/index.css'

export function setupVant(app) {
  app.use(Button)
  app.use(Cell)
  app.use(CellGroup)
  app.use(Field)
  app.use(NavBar)
  app.use(Tabbar)
  app.use(TabbarItem)
  app.use(Card)
  app.use(Tag)
  app.use(List)
  app.use(PullRefresh)
  app.use(Toast)
  app.use(Dialog)
  app.use(Popup)
  app.use(Empty)
  app.use(Grid)
  app.use(GridItem)
  app.use(Icon)
  app.use(Divider)
  app.use(ActionSheet)
  app.use(Search)
  app.use(Tabs)
  app.use(Tab)
  app.use(Badge)
  app.use(Notify)
  app.use(SwipeCell)
  app.use(SubmitBar)
  app.use(Stepper)
  app.use(Loading)
  app.use(Skeleton)
}
