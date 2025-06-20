# 灯影の街 (ToeinoMachi)

## 概要

**灯影の街 (ToeinoMachi)** は、擬似3D技術を用いたアクションゲームです。プレイヤーはキャラクターを操作し、ステージから落ちたり罠に触れずに遠くまで進むことを目的としています。ジャンプやステージの回転を駆使しながら攻略するシンプルながらも戦略的なゲームデザインが特徴です。

本作品は情報メディア学科の授業課題として個人制作したゲームです。

![灯影の街](https://github.com/user-attachments/assets/708d0f4b-3660-440e-bb18-ca4a70d5f4e7)
<!--
スクリーンショットやプレイ動画などがあれば、ここに追加する。
GitHubのWeb上でREADME.mdを編集するとき、画像ファイルを直接ドラッグ＆ドロップで貼り付け可能
-->
## 特徴

- 擬似3D表現（3D技術を用いず、遠近法・透明度・影の表示などで立体感を表現）
- ステージ回転を利用した新感覚のアクション操作
- 頂点アニメーションによる滑らかなキャラクター表現
- アニメーションデータをCSVから読み込み可能（専用エディタをProcessingで作成）

## ゲーム内容

- ステージを左右に回転しながら、落下や罠を回避して進みます
- ステージが進むごとに罠の数が増え、難易度が上昇します
- ステージから落ちたり罠に触れるとゲームオーバーになります

## 操作方法

- **移動**
  - `A`キー：左移動
  - `D`キー：右移動
  - `W`キー：ジャンプ
- **ステージ回転**
  - マウス左クリック：左回転
  - マウス右クリック：右回転
  - ※矢印キーでも代用可能
- **その他**
  - タイトル画面やゲームオーバー画面ではクリックまたは何らかのキー入力で遷移

## 使用技術

- Processing
- CSVファイルによるアニメーションデータ管理
- Cool Textによるタイトルロゴ作成

## 主なシステム構成

- **Inputクラス**：入力を一元管理し、同時入力にも対応
- **Sceneクラス / SceneManagerクラス**：ゲーム全体のシーンクラス構造管理
- **当たり判定**：直方体を用いた衝突検出（複数点による交差判定）
- **影の表示**：プレイヤー直下の地形と交差する面を計算し、影を描画

## 動作環境

- Windows / macOS（C#実行環境が必要）
- Processing IDE

## クレジット

- プログラム・デザイン・サウンド・グラフィック：高木唯衣
- アニメーションエディタ：Processingを利用し自作
- タイトルロゴ：Cool Text使用
- フォント：さざなみ明朝

## ライセンス

本作品は学生による授業課題として制作されたものです。商用利用は禁止されています。
